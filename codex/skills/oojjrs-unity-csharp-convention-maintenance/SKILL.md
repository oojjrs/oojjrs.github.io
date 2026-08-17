---
name: oojjrs-unity-csharp-convention-maintenance
description: Maintain and synchronize the public Unity C# coding-convention document set. Use only when adding, changing, removing, reordering, translating, or validating Unity C# convention rules across the concise Codex copy and Korean/English public representations. Do not use merely to apply the convention while editing Unity code.
---

# oojjrs Unity C# Convention Maintenance

Treat the Unity C# convention as one document set:

- `codex/unity-csharp-coding-convention.md`: the canonical machine-facing source, containing every rule and decision criterion with minimal prose
- `kr/unity/csharp-coding-convention.html`: styled Korean human-facing page with matching rule cards and examples
- `en/unity/csharp-coding-convention.html`: styled English human-facing page with matching rules and examples
- `unity/csharp-coding-convention.html`: redirect only; change it only when the route or default language changes

## Workflow

1. Inspect every representation before editing.
2. Update all applicable representations in the same task. Never publish a rule that exists in only one language or copy.
3. Keep rule order, numbering, meaning, decision criteria, and correct/incorrect examples aligned. The canonical Codex source stays minimal and may omit long examples, but must not omit or weaken a rule. Human-facing HTML may add only presentation and concise explanatory context.
4. Preserve each file's encoding and line endings while editing.
5. Compare rule inventories across all representations, and validate HTML structure only when an HTML representation changed.
6. Report a redirect problem or publication delay only when one actually affects the result.
