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
      if (typeof locale[field] !== 'string' || locale[field].trim().length === 0) {
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

async function readFields(tab, bindings) {
  return await tab.playwright.evaluate((fields) => {
    const select = document.querySelectorAll(fields.languageSelect)[fields.languageIndex];
    if (!select) throw new Error('Language selector is missing.');
    const result = { languageValue: select.value };
    for (const name of ['title', 'summary', 'body']) {
      const elements = document.querySelectorAll(fields[name]);
      if (elements.length !== 1) throw new Error('Ambiguous editor field: ' + name);
      result[name] = elements[0].value;
    }
    return result;
  }, bindings);
}

export async function syncAnnouncementLocales(tab, localizations, languageValues, bindings, mode) {
  assertPackage(localizations, languageValues, bindings, mode);
  await readFields(tab, bindings);
  const verified = [];
  for (const locale of localizations) {
    const value = languageValues[locale.language];
    await tab.playwright.locator(bindings.languageSelect).nth(bindings.languageIndex).selectOption(value);
    await tab.getAXState({ emit: false });
    const active = await readFields(tab, bindings);
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
