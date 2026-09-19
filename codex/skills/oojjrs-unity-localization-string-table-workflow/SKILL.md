---
name: oojjrs-unity-localization-string-table-workflow
description: Maintain and audit Unity Localization StringTable collections, SharedTableData, locale entries, placeholders, and references through Unity's official Localization APIs and Unity CLI. Use when adding, changing, migrating, or validating localized string keys or translations. Do not use for AssetTable or sprite-table work, general Unity asset edits, or source-code localization APIs.
---

# oojjrs Unity Localization String Table Workflow

Use this skill for Unity Localization string-table assets. It owns the Editor-side serialization and metadata safety needed for that scope; do not stack the generic Unity asset workflow.

## Official Editor Path

1. Use the official `$localization` skill for the installed package's API contract and `$unity-cli` for every StringTable, SharedTableData, collection, locale entry, reference, import, and save mutation.
2. Pass `--caller plugin --skill oojjrs-unity-localization-string-table-workflow` on every `unity command` invocation.
3. Never hand-edit StringTable YAML or `.meta` text. Read-only serialized inspection and the bundled validator remain allowed.
4. Let Unity create or update metadata through `AssetDatabase`. Preserve existing GUIDs, and include Unity-generated in-scope `.meta` files with their assets.
5. If the official CLI cannot reach a compatible Editor or the installed Localization APIs do not expose the required operation, stop instead of falling back to serialized text editing.

## Establish The Live Contract

1. Treat user-specified keys, supported locales, placeholder contracts, and collection scope as authoritative.
2. Otherwise discover the current contract from serialized type identifiers and GUID references, not filenames:
   - `StringTableCollection.m_SharedTableData`
   - `SharedTableData.m_Entries`
   - `StringTable.m_SharedData`, `m_LocaleId`, and `m_TableData`
   - Locale assets' `m_Identifier.m_Code`
3. Inspect the live object/API shape through Unity before editing. If the installed Unity Localization version exposes a different contract, adapt to that evidence instead of forcing a remembered schema.
4. Preserve existing keys and translations unless the request changes them. Do not infer a naming migration, supported-locale change, or translation wording from nearby entries.

## Edit Invariants

- Keep every shared entry ID and key unique. Preserve established IDs; create new IDs through Unity's Localization API or the project's established Editor generator rather than inventing or recycling one.
- Keep each locale table on the collection's existing SharedTableData GUID. Preserve every involved `.meta` file and GUID.
- Keep locale entry IDs in exactly the SharedTableData order. Add or remove an entry across every in-scope supported locale in the same change.
- Preserve the same placeholder selector set for an entry in every locale. Translation wording and placeholder order may differ; dropping, adding, or renaming selectors may not.
- Save and reimport through Unity, then read the collection and locale tables back through the Localization API. Treat unexpected GUID, shared-data, entry-order, or membership changes as failures; do not repair the YAML by hand.
- Do not edit StringTableCollection membership, Locale assets, Addressables, fallback configuration, or source code unless the current request includes that scope.

## Read-Only Validation

Run the bundled validator after string-table edits:

```powershell
& <skill-folder>\scripts\Test-UnityLocalizationStringTables.ps1 -ProjectPath <unity-project-or-localization-directory>
```

The script discovers the live string collections, shared data, locale tables, and supported locales. When Addressables data is present, only non-pseudo Locale assets registered with the `Locale` label count as `AvailableLocales`; otherwise it falls back to the discoverable non-pseudo Locale assets. `-ExpectedLocale` overrides discovered locale coverage when the user supplied an explicit set. Use `-SkipLocaleCoverage` only when incomplete tables are an intentional, already established fallback design.

It performs no writes and returns:

- `0`: all enforced checks passed
- `1`: duplicate, reference, coverage, ID/order, placeholder, or YAML-scalar findings
- `2`: invalid input, unreadable assets, or no discoverable string-table schema

Treat a nonzero result as evidence to inspect. Do not mechanically regenerate tables or translations to silence it.
