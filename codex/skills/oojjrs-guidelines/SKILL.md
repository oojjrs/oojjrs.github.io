---
name: oojjrs-guidelines
description: Load the sole canonical shared Codex work-rules URL once per actual-work thread or subagent. Use when host instructions request $oojjrs-guidelines, when repository, code, document, asset, Git, validation, maintenance, or deployment work begins, or when the user asks to inspect or refresh the rules. Do not use for ordinary conversation, factual Q&A, translation, or rewriting. Never substitute workspace, memory, or cached copies.
---

# oojjrs Guidelines

## Canonical Load

1. Run `scripts/Read-OojjrsGuidelines.ps1` once when actual work begins. It fetches only `https://oojjrs.github.io/codex/common-work-guidelines.md`, verifies the final URL, and reports the body's SHA-256.
2. If the script is unavailable, open that exact URL. Never substitute workspace, repository, memory, or cache.
3. Reuse the result in this thread or subagent. Reload only after context restoration, in a new thread or subagent, or on an explicit recheck.
4. If the URL is unreachable, stop rule-dependent work and report the failure.

## Boundary

This loader owns canonical retrieval. Its companion `scripts/Test-OojjrsTextFormat.ps1` implements the common format rule. Consult `codex/skills/index.md` only if routing remains unclear.
