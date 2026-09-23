(function (root) {
  "use strict";

  const timestampPattern = /^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z)\|0x[\da-fA-F]+\|(.*)$/;
  const appPattern = /^(?:[\w가-힣 .()\[\]-]{1,48}>\s+|APP STEP\s*:)/;
  const errorPattern = /(?:\berror\s+CS\d+\b|^(?:Unhandled\s+)?[\w.]*Exception\s*:|\bexception\b|\berror\b|\bfailed\b|\bfatal\b|\bcrash\b)/i;
  const warningPattern = /\b(?:warning|warn|deprecated)\b/i;
  const compilerPattern = /^(?:.+?\(\d+,\d+\):\s*)?(?:error|warning)\s+(?:CS\d+|[A-Z]{2,}\d+):/i;
  const bareIssuePattern = /^(?:Unhandled\s+)?[\w.]+Exception\s*:/;
  const stackPattern = /^(?:\s+at\s+|\s*\(Filename:|\s*--- End of|\s*Rethrow as|UnityEngine\.[\w.]+:|System\.[\w.]+:|[\w.`+<>/]+:[\w.`+<>/]+\s*\(.*\)(?:\s+\(at\s+.+:\d+\))?$)/;

  function terms(value) {
    return String(value || "").split(",").map(function (term) { return term.trim().toLowerCase(); }).filter(Boolean);
  }

  function kindOf(message) {
    if (errorPattern.test(message)) return "error";
    if (warningPattern.test(message)) return "warning";
    if (appPattern.test(message)) return "app";
    return "system";
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
      let skipNextToken = false;

      lines.forEach(function (line) {
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
        if (!timestampMatch && !compilerPattern.test(message) && !bareIssuePattern.test(message) && !/^warn:\s/i.test(message)) return;

        const kind = kindOf(message);
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

  const api = { cleanLog: cleanLog, toText: toText };
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  if (root) root.UnityLogParser = api;
})(typeof window !== "undefined" ? window : null);
