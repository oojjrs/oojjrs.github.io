import assert from 'node:assert/strict';
import { syncAnnouncementLocales } from './sync-announcement-locales.mjs';

const editorUrl = 'https://steamcommunity.com/games/123/partnerevents/edit/456';
const languageValues = { koreana: 'ko', english: 'en' };
const bindings = {
  languageSelect: '#language', languageIndex: 0,
  title: '#title', summary: '#summary', body: '#body',
  titleLimit: 80, summaryLimit: 180
};
const localizations = [
  { language: 'koreana', title: '승인 제목', summary: '', body: '승인 본문' },
  { language: 'english', title: 'Approved title', summary: '', body: 'Approved body' }
];

function approvalFor(locales) {
  return {
    userInstruction: '제시한 제목과 본문을 해당 공지에 사용하고 요약은 비워 둬.',
    editorUrl,
    bindings: { ...bindings },
    languageValues: { ...languageValues },
    localizations: locales.map((locale) => ({ ...locale }))
  };
}

function mockEditor(initial, onState) {
  const state = new Map(initial.map((locale) => [languageValues[locale.language], { ...locale }]));
  const mock = { editorUrl, active: 'ko', reads: 0, selections: [], fills: [] };
  mock.tab = {
    playwright: {
      evaluate: async () => {
        mock.reads++;
        return { ...state.get(mock.active), editorUrl: mock.editorUrl, languageValue: mock.active };
      },
      locator: (selector) => {
        if (selector === bindings.languageSelect) {
          return {
            nth: (index) => {
              assert.equal(index, bindings.languageIndex);
              return {
                selectOption: async (value) => {
                  assert.ok(state.has(value));
                  mock.active = value;
                  mock.selections.push(value);
                }
              };
            }
          };
        }
        const field = ['title', 'summary', 'body'].find((name) => bindings[name] === selector);
        assert.ok(field, 'Unexpected field selector.');
        return {
          fill: async (value) => {
            state.get(mock.active)[field] = value;
            mock.fills.push({ language: mock.active, field, value });
          }
        };
      }
    },
    getAXState: async () => {
      if (onState) onState();
      return {};
    }
  };
  return mock;
}

let cases = 0;
async function rejectsBeforeInput(approval, pattern, destination) {
  const mock = mockEditor(localizations);
  if (destination) mock.editorUrl = destination;
  await assert.rejects(
    () => syncAnnouncementLocales(mock.tab, localizations, languageValues, bindings, 'Apply', approval),
    pattern
  );
  assert.equal(mock.fills.length, 0);
  assert.equal(mock.selections.length, 0);
  cases++;
}

await rejectsBeforeInput(undefined, /prior user text-approval record/);

const noInstruction = approvalFor(localizations);
noInstruction.userInstruction = '';
await rejectsBeforeInput(noInstruction, /prior user text-approval record/);

const differentWording = approvalFor(localizations);
differentWording.localizations[1].body = 'Different body';
await rejectsBeforeInput(differentWording, /Approved wording mismatch/);

const differentPlacement = approvalFor(localizations);
differentPlacement.bindings.body = '#other-body';
await rejectsBeforeInput(differentPlacement, /Approved editor placement mismatch/);

const differentLanguage = approvalFor(localizations);
differentLanguage.languageValues.english = 'other';
await rejectsBeforeInput(differentLanguage, /Approved language placement mismatch/);

const partialCoverage = approvalFor(localizations);
partialCoverage.localizations.pop();
await rejectsBeforeInput(partialCoverage, /Approved language coverage mismatch/);

const duplicateLanguages = approvalFor(localizations);
duplicateLanguages.localizations[1].language = 'koreana';
await rejectsBeforeInput(duplicateLanguages, /invalid or duplicate languages/);

await rejectsBeforeInput(
  approvalFor(localizations),
  /active editor does not match/,
  'https://steamcommunity.com/games/123/partnerevents/edit/other'
);

const apply = mockEditor(localizations.map((locale) => ({
  ...locale, title: 'Old title', summary: 'Old summary', body: 'Old body'
})));
const applied = await syncAnnouncementLocales(
  apply.tab, localizations, languageValues, bindings, 'Apply', approvalFor(localizations)
);
assert.deepEqual(applied, localizations);
assert.equal(apply.fills.length, 6);
assert.equal(apply.fills.filter((entry) => entry.field === 'summary' && entry.value === '').length, 2);
cases++;

const mutableLocales = localizations.map((locale) => ({ ...locale }));
const mutableValues = { ...languageValues };
const mutableBindings = { ...bindings };
const frozenApproval = approvalFor(mutableLocales);
const changingInputs = mockEditor(localizations, () => {
  mutableLocales[1].body = 'Unapproved later wording';
  mutableValues.english = 'other';
  mutableBindings.body = '#other-body';
});
const stable = await syncAnnouncementLocales(
  changingInputs.tab, mutableLocales, mutableValues, mutableBindings, 'Apply', frozenApproval
);
assert.deepEqual(stable, localizations);
assert.equal(changingInputs.fills.some((entry) => entry.value === 'Unapproved later wording'), false);
cases++;

const verify = mockEditor(localizations);
const verified = await syncAnnouncementLocales(
  verify.tab, localizations, languageValues, bindings, 'Verify', undefined
);
assert.deepEqual(verified, localizations);
assert.equal(verify.fills.length, 0);
cases++;

console.log(cases + ' approval and read-only regression cases passed using an in-memory editor.');
