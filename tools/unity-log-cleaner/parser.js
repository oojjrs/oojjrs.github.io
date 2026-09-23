(function (root) {
  "use strict";

  const timestampPattern = /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z)\|0x[\da-fA-F]+\|(.*)$/;
  const appPattern = /^(?:[\w가-힣 .()\[\]-]{1,48}>\s+|APP STEP\s*:)/;
  const errorPattern = /(?:\berror\s+CS\d+\b|^(?:Unhandled\s+)?[\w.]*Exception\s*:|\bexception\b|\berror\b|\bfailed\b|\bfatal\b|\bcrash\b)/i;
  const warningPattern = /\b(?:warning|warn|deprecated)\b/i;
  const compilerPattern = /^(?:.+?\(\d+,\d+\):\s*)?(?:error|warning)\s+(?:CS\d+|[A-Z]{2,}\d+):/i;
  const bareIssuePattern = /^(?:Unhandled\s+)?[\w.]+Exception\s*:/;
  const stackStartPattern = /^(?:\s*at\s+\S|[^\s:]+:[^\s:]+\s*\(.*\)(?:\s+\(at\s+.+:\d+\))?$)/;
  const stackPattern = /^(?:\s*\(Filename:|\s*--- End of|\s*Rethrow as|\s*at\s+\S|[^\s:]+:[^\s:]+\s*\(.*\)(?:\s+\(at\s+.+:\d+\))?$)/;

  function terms(value) {
    return String(value || "").split(",").map(function (term) { return term.trim().toLowerCase(); }).filter(Boolean);
  }

  function kindOf(message, stackKind) {
    if (stackKind === "error") return "error";
    if (stackKind === "warning") return "warning";
    if (errorPattern.test(message)) return "error";
    if (warningPattern.test(message)) return "warning";
    if (stackKind || appPattern.test(message)) return "app";
    return "system";
  }

  function stackMessages(lines) {
    const messages = new Map();
    for (let index = 1; index < lines.length; index += 1) {
      const current = lines[index].trim();
      const previous = lines[index - 1].trim();
      if (!stackStartPattern.test(current) || !previous || stackPattern.test(previous)) continue;
      let kind = "app";
      for (let next = index; next < lines.length && lines[next].trim(); next += 1) {
        const frame = lines[next].trim();
        if (!stackPattern.test(frame)) break;
        if (/\b(?:LogError|LogException|LogAssertion|Assert)\s*\(/.test(frame)) kind = "error";
        else if (kind !== "error" && /\bLogWarning\s*\(/.test(frame)) kind = "warning";
      }
      messages.set(index - 1, kind);
    }
    return messages;
  }

  function cleanLog(sources, options) {
    const mode = options.mode || "focus";
    const includes = terms(options.include);
    const excludes = terms(options.exclude);
    const group = options.group !== false;
    const rows = [];
    const grouped = new Map();
    let totalLines = 0;
    let candidates = 0;
    let matched = 0;

    (sources || []).forEach(function (source) {
      const lines = String(source.text || "").split(/\r\n|\n|\r/);
      totalLines += lines.length;
      const stackAnchors = stackMessages(lines.map(function (line) { return line.replace(/\x1b\[[0-9;]*m/g, ""); }));
      let skipNextToken = false;

      lines.forEach(function (line, index) {
        const plain = line.replace(/\x1b\[[0-9;]*m/g, "");
        const timestampMatch = plain.match(timestampPattern);
        const timestamp = timestampMatch ? timestampMatch[1] : "";
        const message = (timestampMatch ? timestampMatch[2] : plain).trim();
        if (!message) return;
        if (skipNextToken) {
          skipNextToken = false;
          return;
        }
        if (message === "-accessToken") {
          skipNextToken = true;
          return;
        }
        if (stackPattern.test(message)) return;
        if (!stackAnchors.has(index) && !timestampMatch && !compilerPattern.test(message) && !bareIssuePattern.test(message) && !/^warn:\s/i.test(message) && !appPattern.test(message)) return;

        const kind = kindOf(message, stackAnchors.get(index));
        candidates += 1;
        if (mode === "focus" && kind === "system") return;
        if (mode === "problems" && kind !== "error" && kind !== "warning") return;
        const lower = message.toLowerCase();
        if (includes.length && !includes.some(function (term) { return lower.includes(term); })) return;
        if (excludes.some(function (term) { return lower.includes(term); })) return;
        matched += 1;

        const name = source.name || "붙여넣기";
        const key = name + "\u0000" + kind + "\u0000" + message;
        if (group && grouped.has(key)) {
          const existing = grouped.get(key);
          existing.count += 1;
          if (timestamp) existing.lastTime = timestamp;
          return;
        }
        const row = { source: name, kind: kind, message: message, time: timestamp, lastTime: timestamp, count: 1 };
        rows.push(row);
        if (group) grouped.set(key, row);
      });
    });

    return { rows: rows, totalLines: totalLines, candidates: candidates, matched: matched };
  }

  function toText(rows) {
    return rows.map(function (row) {
      const time = row.time ? row.time.replace("T", " ").replace("Z", "") + "  " : "";
      const count = row.count > 1 ? "  ×" + row.count : "";
      return time + "[" + row.kind.toUpperCase() + "] " + row.message + count;
    }).join("\n");
  }

  function extractEnvironment(value) {
    const text = String(value || "");
    const fields = [];
    const unity = text.match(/\bVersion is '([^'\s]+)/i) || text.match(/^Initialize engine version:\s*([^\s]+)/im);
    const os = text.match(/^OS:\s*'([^']+)'/im) || text.match(/^OS:\s*([^\r\n]+)/im);
    const architecture = text.match(/^Process architecture:\s*([^\r\n]+)/im) || text.match(/^System\s+architecture:\s*([^\r\n]+)/im);
    const memory = text.match(/\bPhysical Memory:\s*(\d+\s*MB)\b/i);
    const build = text.match(/\bBuild Type '([^']+)'/i);
    const hostIp = text.match(/^Found\s+\d+\s+interfaces?\s+on\s+host\s*:\s*\d+\)\s*([^\s\r\n]+)/im);
    const playerIp = text.match(/Player connection[^\r\n]*\[IP\]\s*([^\s\[\]"']+)/i);
    const playerPort = text.match(/Player connection[^\r\n]*\[Port\]\s*(\d+)/i);
    const udpBroadcast = text.match(/Started UDP target info broadcast[^\r\n]*\bon\s*\[([^\]\r\n]+)\]/i);
    const project = text.match(/Player connection[^\r\n]*\[ProjectName\]\s*([^\s\[\]"']+)/i);
    const platform = text.match(/Player connection[^\r\n]*\[PackageName\]\s*([^\s\[\]"']+)/i);
    let graphicsApi = "";
    const graphics = {};
    const lines = text.split(/\r\n|\n|\r/);
    for (let index = 0; index < lines.length; index += 1) {
      const heading = (lines[index].match(timestampPattern) || [null, null, lines[index]])[2].trim();
      const section = heading.match(/^(Direct3D|Vulkan|OpenGL):$/i);
      if (!section) continue;
      graphicsApi = section[1];
      for (let offset = 1; offset <= 7 && index + offset < lines.length; offset += 1) {
        const line = (lines[index + offset].match(timestampPattern) || [null, null, lines[index + offset]])[2].trim();
        const detail = line.match(/^(Version|Renderer|Vendor|VRAM|Driver):\s*(.+)$/i);
        if (!detail) break;
        graphics[detail[1].toLowerCase()] = detail[2].trim();
      }
      break;
    }
    if (unity) fields.push({ label: "Unity", value: unity[1].trim() });
    if (os) fields.push({ label: "OS", value: os[1].replace(/\s+/g, " ").trim() });
    if (architecture) fields.push({ label: "아키텍처", value: architecture[1].trim() });
    if (memory) fields.push({ label: "메모리", value: memory[1].replace(/\s+/g, " ").trim() });
    if (build) fields.push({ label: "빌드", value: build[1].trim() });
    if (graphicsApi === "Direct3D") fields.push({ label: "DX", value: graphics.version || graphicsApi });
    else if (graphicsApi) fields.push({ label: "그래픽 API", value: graphics.version || graphicsApi });
    if (graphics.renderer) fields.push({ label: "그래픽카드", value: graphics.renderer.replace(/\s+\(ID=0x[\da-f]+\)$/i, "") });
    if (graphics.vram) fields.push({ label: "VRAM", value: graphics.vram });
    if (graphics.driver) fields.push({ label: "Driver", value: graphics.driver });
    if (platform) fields.push({ label: "플랫폼", value: platform[1] });
    if (project) fields.push({ label: "프로젝트", value: project[1] });
    if (playerIp || hostIp) fields.push({ label: "IP", value: (playerIp || hostIp)[1] });
    if (playerPort) fields.push({ label: "포트", value: playerPort[1] });
    if (udpBroadcast) fields.push({ label: "UDP 방송 주소", value: udpBroadcast[1] });
    return fields;
  }

  const api = { cleanLog: cleanLog, toText: toText, extractEnvironment: extractEnvironment };
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.UnityLogParser = api;
})(typeof window !== "undefined" ? window : null);
