(function () {
  "use strict";

  const fileInput = document.getElementById("file-input");
  const openButton = document.getElementById("open-button");
  const clearButton = document.getElementById("clear-button");
  const dropZone = document.getElementById("drop-zone");
  const sourceInput = document.getElementById("source-input");
  const outputInput = document.getElementById("output-input");
  const sourceMeta = document.getElementById("source-meta");
  const outputMeta = document.getElementById("output-meta");
  const status = document.getElementById("status");
  const environment = document.getElementById("environment");
  const modeInput = document.getElementById("mode-input");
  const includeInput = document.getElementById("include-input");
  const excludeInput = document.getElementById("exclude-input");
  const wrapInput = document.getElementById("wrap-input");
  const groupInput = document.getElementById("group-input");
  const copyButton = document.getElementById("copy-button");
  const downloadButton = document.getElementById("download-button");
  let timer;

  function renderEnvironment(value) {
    const fields = window.UnityLogParser.extractEnvironment(value);
    environment.replaceChildren();
    fields.forEach(function (field) {
      const item = document.createElement("span");
      const label = document.createElement("strong");
      label.textContent = field.label;
      item.append(label, document.createTextNode(field.value));
      environment.append(item);
    });
    environment.hidden = fields.length === 0;
  }

  function applyWrap() {
    [sourceInput, outputInput].forEach(function (editor) {
      editor.wrap = wrapInput.checked ? "soft" : "off";
      editor.classList.toggle("no-wrap", !wrapInput.checked);
    });
  }

  function run() {
    const value = sourceInput.value;
    if (!value.trim()) {
      sourceMeta.textContent = "";
      outputMeta.textContent = "";
      outputInput.value = "";
      environment.replaceChildren();
      environment.hidden = true;
      copyButton.disabled = true;
      downloadButton.disabled = true;
      status.textContent = "";
      return;
    }
    const result = window.UnityLogParser.cleanLog([{ name: "원본", text: value }], {
      mode: modeInput.value,
      include: includeInput.value,
      exclude: excludeInput.value,
      group: groupInput.checked
    });
    outputInput.value = window.UnityLogParser.toText(result.rows);
    renderEnvironment(value);
    sourceMeta.textContent = result.totalLines.toLocaleString() + "줄";
    outputMeta.textContent = result.rows.length.toLocaleString() + "건";
    copyButton.disabled = result.rows.length === 0;
    downloadButton.disabled = result.rows.length === 0;
    status.textContent = result.rows.length + "건 정제됨";
  }

  function scheduleRun() {
    clearTimeout(timer);
    timer = setTimeout(run, 90);
  }

  async function loadFiles(files) {
    const selected = Array.from(files).filter(function (file) { return /\.(?:log|txt)$/i.test(file.name); });
    if (!selected.length) {
      status.textContent = ".log 또는 .txt 파일을 선택해 주세요.";
      return;
    }
    try {
      const contents = await Promise.all(selected.map(async function (file) { return await file.text(); }));
      sourceInput.value = contents.join("\n\n");
      run();
    } catch (error) {
      status.textContent = "파일을 읽지 못했습니다.";
    }
  }

  openButton.addEventListener("click", function () { fileInput.click(); });
  clearButton.addEventListener("click", function () {
    clearTimeout(timer);
    fileInput.value = "";
    sourceInput.value = "";
    run();
    sourceInput.focus();
  });
  fileInput.addEventListener("change", function () { loadFiles(fileInput.files); });
  sourceInput.addEventListener("input", scheduleRun);
  wrapInput.addEventListener("change", applyWrap);
  [modeInput, includeInput, excludeInput, groupInput].forEach(function (input) { input.addEventListener("input", scheduleRun); });
  ["dragenter", "dragover"].forEach(function (eventName) {
    dropZone.addEventListener(eventName, function (event) { event.preventDefault(); dropZone.classList.add("dragging"); });
  });
  ["dragleave", "drop"].forEach(function (eventName) {
    dropZone.addEventListener(eventName, function (event) { event.preventDefault(); dropZone.classList.remove("dragging"); });
  });
  dropZone.addEventListener("drop", function (event) { loadFiles(event.dataTransfer.files); });
  copyButton.addEventListener("click", async function () {
    try {
      await navigator.clipboard.writeText(outputInput.value);
      status.textContent = "정제 결과 복사됨";
    } catch (error) {
      status.textContent = "복사에 실패했습니다.";
    }
  });
  downloadButton.addEventListener("click", function () {
    const blob = new Blob([outputInput.value], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "unity-log-cleaned.txt";
    link.click();
    setTimeout(function () { URL.revokeObjectURL(url); }, 1000);
  });
  applyWrap();
})();
