(function () {
  "use strict";

  const fileInput = document.getElementById("file-input");
  const dropZone = document.getElementById("drop-zone");
  const pasteInput = document.getElementById("paste-input");
  const inputNote = document.getElementById("input-note");
  const includeInput = document.getElementById("include-input");
  const excludeInput = document.getElementById("exclude-input");
  const groupInput = document.getElementById("group-input");
  const runButton = document.getElementById("run-button");
  const stats = document.getElementById("stats");
  const resultList = document.getElementById("result-list");
  const resultNote = document.getElementById("result-note");
  const copyButton = document.getElementById("copy-button");
  const downloadButton = document.getElementById("download-button");
  const labels = { app: "게임", error: "오류", warning: "경고", system: "시스템" };
  let loadedFiles = [];
  let currentRows = [];

  function make(tag, className, content) {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (content !== undefined) element.textContent = content;
    return element;
  }

  function setEmpty(message) {
    resultList.replaceChildren();
    const empty = make("div", "empty-state");
    empty.append(make("span", "", "⌁"), make("p", "", message));
    resultList.append(empty);
  }

  function render(data) {
    currentRows = data.rows;
    stats.replaceChildren();
    ["입력 " + data.totalLines.toLocaleString() + "줄", "후보 " + data.candidates.toLocaleString() + "건", "일치 " + data.matched.toLocaleString() + "건", "표시 " + data.rows.length.toLocaleString() + "건"].forEach(function (item) {
      stats.append(make("span", "", item));
    });
    copyButton.disabled = data.rows.length === 0;
    downloadButton.disabled = data.rows.length === 0;
    resultList.replaceChildren();
    if (!data.rows.length) {
      setEmpty("조건에 맞는 메시지가 없습니다. 정제 범위나 검색어를 바꿔 보세요.");
      resultNote.textContent = "";
      return;
    }

    const limit = Math.min(data.rows.length, 700);
    const fragment = document.createDocumentFragment();
    data.rows.slice(0, limit).forEach(function (row) {
      const entry = make("div", "entry");
      const time = make("time", "", row.time ? row.time.replace("T", " ").replace("Z", "") : "시간 정보 없음");
      if (row.time) time.dateTime = row.time;
      const kind = make("span", "kind " + row.kind, labels[row.kind]);
      const message = make("span", "message", row.message);
      const count = make("span", "count", row.count > 1 ? "×" + row.count : "");
      entry.title = row.source;
      entry.append(time, kind, message, count);
      fragment.append(entry);
    });
    resultList.append(fragment);
    resultNote.textContent = data.rows.length > limit ? "화면에는 처음 700건만 표시합니다. 복사와 TXT 저장에는 전체 결과가 포함됩니다." : "파일별 원본 순서를 유지합니다. 반복 메시지는 처음 등장한 위치에 묶입니다.";
  }

  function run() {
    const sources = loadedFiles.slice();
    if (pasteInput.value.trim()) sources.push({ name: "붙여넣기", text: pasteInput.value });
    if (!sources.length) {
      stats.replaceChildren(make("span", "", "로그를 넣고 정제해 보세요."));
      setEmpty("파일을 선택하거나 로그 텍스트를 붙여넣어 주세요.");
      currentRows = [];
      copyButton.disabled = true;
      downloadButton.disabled = true;
      resultNote.textContent = "";
      return;
    }
    const mode = document.querySelector('input[name="mode"]:checked').value;
    render(window.UnityLogParser.cleanLog(sources, { mode: mode, include: includeInput.value, exclude: excludeInput.value, group: groupInput.checked }));
  }

  async function loadFiles(files) {
    const selected = Array.from(files).filter(function (file) { return /\.(?:log|txt)$/i.test(file.name); });
    if (!selected.length) {
      inputNote.textContent = "읽을 수 있는 .log 또는 .txt 파일을 선택해 주세요.";
      return;
    }
    try {
      loadedFiles = await Promise.all(selected.map(async function (file) { return { name: file.name, text: await file.text() }; }));
      inputNote.textContent = loadedFiles.length + "개 파일 선택됨 · 브라우저에서만 읽었습니다.";
      run();
    } catch (error) {
      inputNote.textContent = "파일을 읽지 못했습니다. 다시 선택해 주세요.";
    }
  }

  fileInput.addEventListener("change", function () { loadFiles(fileInput.files); });
  ["dragenter", "dragover"].forEach(function (eventName) {
    dropZone.addEventListener(eventName, function (event) { event.preventDefault(); dropZone.classList.add("dragging"); });
  });
  ["dragleave", "drop"].forEach(function (eventName) {
    dropZone.addEventListener(eventName, function (event) { event.preventDefault(); dropZone.classList.remove("dragging"); });
  });
  dropZone.addEventListener("drop", function (event) { loadFiles(event.dataTransfer.files); });
  runButton.addEventListener("click", run);
  document.querySelectorAll('input[name="mode"]').forEach(function (input) { input.addEventListener("change", run); });
  groupInput.addEventListener("change", run);
  copyButton.addEventListener("click", async function () {
    try {
      await navigator.clipboard.writeText(window.UnityLogParser.toText(currentRows));
      copyButton.textContent = "복사됨";
      setTimeout(function () { copyButton.textContent = "복사"; }, 1700);
    } catch (error) {
      resultNote.textContent = "복사에 실패했습니다. TXT 저장을 이용해 주세요.";
    }
  });
  downloadButton.addEventListener("click", function () {
    const blob = new Blob([window.UnityLogParser.toText(currentRows)], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "unity-log-cleaned.txt";
    link.click();
    setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
  });
})();
