function assertPackage(localizations, languageValues, bindings, mode) {
  if (mode !== 'Apply' && mode !== 'Verify') {
    throw new Error('Mode must be Apply or Verify.');
  }
  if (!Array.isArray(localizations) || localizations.length === 0) {
    throw new Error('The announcement has no localizations.');
  }
  const languages = new Set();
  const values = new Set();
  for (const locale of localizations) {
    const value = languageValues[locale.language];
    if (typeof value !== 'string' || languages.has(locale.language) || values.has(value)) {
      throw new Error('Missing or duplicate language mapping: ' + locale.language);
    }
    for (const field of ['title', 'summary', 'body']) {
      if (typeof locale[field] !== 'string' || (field !== 'summary' && locale[field].trim().length === 0)) {
        throw new Error('Missing ' + field + ': ' + locale.language);
      }
    }
    if (locale.title.length > bindings.titleLimit || locale.summary.length > bindings.summaryLimit) {
      throw new Error('Editor text limit exceeded: ' + locale.language);
    }
    languages.add(locale.language);
    values.add(value);
  }
}

function assertTextApproval(localizations, languageValues, bindings, textApproval) {
  if (!textApproval || typeof textApproval.userInstruction !== 'string' ||
      textApproval.userInstruction.trim().length === 0 ||
      typeof textApproval.editorUrl !== 'string' || !textApproval.bindings ||
      !textApproval.languageValues || !Array.isArray(textApproval.localizations)) {
    throw new Error('Apply requires a prior user text-approval record.');
  }
  try {
    new URL(textApproval.editorUrl);
  } catch {
    throw new Error('The text-approval record must identify an absolute editor URL.');
  }
  for (const key of ['languageSelect', 'languageIndex', 'title', 'summary', 'body']) {
    if (textApproval.bindings[key] === undefined || textApproval.bindings[key] !== bindings[key]) {
      throw new Error('Approved editor placement mismatch: ' + key);
    }
  }
  if (textApproval.localizations.length !== localizations.length) {
    throw new Error('Approved language coverage mismatch.');
  }
  const approved = new Map();
  for (const locale of textApproval.localizations) {
    if (!locale || typeof locale.language !== 'string' || approved.has(locale.language)) {
      throw new Error('The text-approval record has invalid or duplicate languages.');
    }
    approved.set(locale.language, locale);
  }
  for (const locale of localizations) {
    const expected = approved.get(locale.language);
    if (!expected || textApproval.languageValues[locale.language] !== languageValues[locale.language]) {
      throw new Error('Approved language placement mismatch: ' + locale.language);
    }
    for (const field of ['title', 'summary', 'body']) {
      if (expected[field] !== locale[field]) {
        throw new Error('Approved wording mismatch in ' + field + ': ' + locale.language);
      }
    }
  }
  return textApproval.editorUrl;
}

function assertEditorUrl(fields, approvedEditorUrl) {
  if (approvedEditorUrl !== null && fields.editorUrl !== approvedEditorUrl) {
    throw new Error('The active editor does not match the text-approval record.');
  }
}

async function readFields(tab, bindings) {
  return await tab.playwright.evaluate((fields) => {
    const select = document.querySelectorAll(fields.languageSelect)[fields.languageIndex];
    if (!select) throw new Error('Language selector is missing.');
    const result = { editorUrl: window.location.href, languageValue: select.value };
    for (const name of ['title', 'summary', 'body']) {
      const elements = document.querySelectorAll(fields[name]);
      if (elements.length !== 1) throw new Error('Ambiguous editor field: ' + name);
      result[name] = elements[0].value;
    }
    return result;
  }, bindings);
}

export async function syncAnnouncementLocales(tab, localizations, languageValues, bindings, mode, textApproval) {
  assertPackage(localizations, languageValues, bindings, mode);
  localizations = localizations.map((locale) => ({
    language: locale.language, title: locale.title, summary: locale.summary, body: locale.body
  }));
  languageValues = { ...languageValues };
  bindings = { ...bindings };
  const approvedEditorUrl = mode === 'Apply'
    ? assertTextApproval(localizations, languageValues, bindings, textApproval)
    : null;
  const initial = await readFields(tab, bindings);
  assertEditorUrl(initial, approvedEditorUrl);
  const verified = [];
  for (const locale of localizations) {
    const value = languageValues[locale.language];
    await tab.playwright.locator(bindings.languageSelect).nth(bindings.languageIndex).selectOption(value);
    await tab.getAXState({ emit: false });
    const active = await readFields(tab, bindings);
    assertEditorUrl(active, approvedEditorUrl);
    if (active.languageValue !== value) {
      throw new Error('Active language mismatch: ' + locale.language);
    }
    if (mode === 'Apply') {
      for (const name of ['title', 'summary', 'body']) {
        await tab.playwright.locator(bindings[name]).fill(locale[name]);
      }
      await tab.getAXState({ emit: false });
    }
    const actual = await readFields(tab, bindings);
    assertEditorUrl(actual, approvedEditorUrl);
    if (actual.languageValue !== value) {
      throw new Error('Language changed during input: ' + locale.language);
    }
    for (const name of ['title', 'summary', 'body']) {
      if (actual[name] !== locale[name]) {
        throw new Error('Content mismatch in ' + name + ': ' + locale.language);
      }
    }
    verified.push({ language: locale.language, title: actual.title, summary: actual.summary, body: actual.body });
  }
  return verified;
}
