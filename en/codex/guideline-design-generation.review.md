---
layout: page
lang: en
title: "Design.html Planning Document Standard"
alternate_url: /kr/codex/guideline-design-generation.review.html
category: "REVIEW"
description: "A public review standard for creating, adding, reviewing, and updating project Design.html planning documents."
permalink: /en/codex/guideline-design-generation.review.html
toc_items:
  - id: roles
    label: "Role separation"
  - id: start
    label: "Start standard"
  - id: duplication
    label: "Duplicated rules"
  - id: design
    label: "Design.html"
  - id: design-hierarchy
    label: "Planning hierarchy"
  - id: samples
    label: "Sample files"
  - id: skills
    label: "Skills"
  - id: validation
    label: "Validation"
  - id: files
    label: "Storage locations"
---

[← Codex]({{ "/en/codex/" | relative_url }}) · [한국어]({{ "/kr/codex/guideline-design-generation.review.html" | relative_url }})
{: .article-backlink }

This is the public standard for project-level `Design.html` documents.
{: .article-lead }

When Codex creates, extends, reviews, or edits `Design.html`, it must first check the [common work guidelines](https://oojjrs.github.io/engineering-notes/en/codex/common-work-guidelines.html), this planning-document standard, and the live project document.
{: .article-principle }

## Role separation {#roles}

### Codex execution rules

Work-operation rules refer to the [Codex Common Work Guidelines](https://oojjrs.github.io/engineering-notes/en/codex/common-work-guidelines.html). Planning-document writing rules follow this document and the public standard referenced by the `project-design-document-router` skill.

### Human review surface

This page is the public document that a user can inspect in the browser. Local Markdown files are internal references for Codex; the human-facing review standard is this GitHub Pages document.

Project repositories should not assume that `README.md` or `AGENTS.md` always exists. The current standard centers on the project's `Design.html` and the shared common work-guidelines page.

**Domain separation:** work guidelines and planning-document guidelines are different document surfaces. The common work guidelines describe how Codex works, validates, and keeps commit scope. `Design.html` describes only the current decisions, implementation standards, and UX rationale for the game or product. Do not put work procedures, queue operations, validation commands, or commit rules into the body of `Design.html`.

## Start standard {#start}

1. Reopen the live project `Design.html`, and check the GitHub common work guidelines for operating rules.
2. Treat `README.md` primarily as a public GitHub-facing document unless the project says otherwise.
3. Read `AGENTS.md` if it exists, but do not assume every new project must have one.
4. Run `git status --short --branch` to check existing changes and signs of parallel work.
5. Treat the current project files as the source of truth. Do not judge only from older memory or external drafts.

## Duplicated rules {#duplication}

Personal Codex settings are important, but they may not be synchronized across environments. Do not copy every personal setting into every project, but do repeat rules whose absence can cause real damage.

- Work that is hard to undo requires approval unless the immediately preceding user instruction explicitly requested it.
- Preserve the original encoding and line endings. New text defaults to UTF-8 No-BOM and CRLF.
- Feedback and document writing are Korean by default.
- If `Design.html` exists, read it before work and update it when planning state changes. Operating rules should be checked from the shared work-guidelines URL, not copied into the project document.
- If code was changed after the latest planning artifact and now conflicts with `Design.html`, the code is the implementation standard. Update the planning document to match the code and latest intent.
- Preserve unrelated dirty changes. Do not revert them.

## Design.html {#design}

`Design.html` is a game or product content guide read by both humans and Codex. It preserves what is being made and why those choices were made, so later work does not lose direction.

The planning document is not a history file for the full conversation or every intermediate result. Keep only final UX decisions, implementation standards, current implementation state, and the reasons those decisions were chosen.
{: .article-note }

- When a later version or final result exists, remove temporary alternatives, rejected candidates, and intermediate-output explanations.
- Candidate images, videos, sounds, comparison tables, contact sheets, temporary conversions, and rejected drafts produced during planning belong only under the project root `$Trash`. `DesignAssets` and `GuidelinesAssets` should contain only confirmed materials referenced by the current final document.
- Aim for a document that matches the current implementation. If an assumption is not implemented, mark it as an unresolved item.
- When code and the planning document conflict, prefer the code if it reflects the latest implementation, then update the planning document to match.
- Prefer immediately understandable media such as images, video, audio, and previews over long prose.
- Use writing to explain what the media cannot show and why the decision was made.
- Use tooltip-style help for domain-specific terms, proper nouns, project-internal names, abbreviations, art terms, and system terms that need local explanation.
- If Codex does not know what a project term means, it must ask the user instead of inventing a definition.
- Keep planning-document rules in this review document and skill instructions. Do not expose lengthy meta rules inside the actual `Design.html` body.
- Keep section links in a separate floating table of contents rather than mixing navigation into top body cards.
- Put completed sections and sections that contain current implementation or decisions first. The first reading path should show content that is already worth reading.
- If there are many unwritten section candidates, do not scatter them through the middle of the document. Group them near the end in one large collapsed section such as `Unwritten sections` or `Future section candidates`.
- The floating table of contents should also show completed sections first. Unwritten sections should be represented by a single later link or collapsed group, with a count such as `Needs writing N` when useful.
- The first structure of a new planning document may use the default categories below as candidates. Empty candidates should go into the later collapsed group so they do not interrupt the reading flow.
- Do not collect category-specific implementation rules in one separate section. Place category standards and decision rationale next to the relevant data, image, table, or sound.
- Do not place document signals, writing instructions, or category summaries immediately under the header. The first body section should begin with actual game or product content.
- The `Design.html` header should contain only the document title and two external reference links: [Codex Common Work Guidelines](https://oojjrs.github.io/engineering-notes/en/codex/common-work-guidelines.html) and [Planning Document Standard](https://oojjrs.github.io/engineering-notes/en/codex/guideline-design-generation.review.html). The links are references, not a reason to mix operating rules into the `Design.html` body.

### Default game-planning categories

Use these categories as the first skeleton for a new game `Design.html`. Delete or merge items that do not fit the project. Genre-specific topics such as puzzle stages, factory logistics, or strategic diplomacy should first be placed inside the nearest general category instead of becoming independent top-level categories.

- Core direction: identity, genre, progression model, core fun, win/loss, difficulty, mastery
- World and space: setting, story, factions, worlds, regions, dungeons, background, movement and discovery
- Level and content structure: stages, chapters, missions, campaigns, difficulty curve, content cycle
- Characters and growth: characters, roles, stats, skills, traits, status effects, level, allies and enemies
- Rules and calculation model: turns, ticks, formulas, score, probability, generation rules, AI, economy and combat interpretation
- Items and economy: items, equipment, resources, currencies, rewards, drops, inventory, shop, blueprints, crafting
- Quests and events: quests, requests, events, achievements, ranking goals, tutorial, repeatable and endgame content
- Interaction and combat: controls, targeting, board or tile rules, action feedback, failure and retry
- Presentation and communication: dialogue, voice, cutscenes, camera, sound, UI text, notifications and logs
- UI and convenience systems: HUD, menus, settings, save, accessibility, input, localization, help and tooltips
- Meta systems: unlocks, collection, progress, multiplayer, lobby/matchmaking, social, server sync, live operations
- Undecided and exclusions: open questions, parked items, excluded directions, risks, next-version candidates

## Planning hierarchy {#design-hierarchy}

`Design.html` should move from the biggest structure to concrete details as the reader goes down the page. The first section should be open and answer large questions such as goal, genre, and progression. Later sections should group similar abstraction levels and may be collapsed.

- What is the goal of this game: goal, genre, progression, surface promise
- How does it progress: progression loop, where the fun happens, how the user gets better
- What does the designer intend: what the user should learn, misunderstand, or discover later
- Then move into world, systems, content, expression, exceptions, undecided items, and change history.

### Details that deserve special care

- Why a feature or system exists
- Why this direction was chosen over alternatives
- What problem the decision solved
- Technical, UX, worldbuilding, or production-scope constraints that limited the decision
- The design intent that follow-up workers must preserve

### Default included content

- Current game or product direction
- User experience goals
- Core systems and feature areas
- Screens, flows, content, and rule plans
- Decision records with reasons
- Rejected alternatives that help explain the selected direction
- Open questions and risks
- Asset and reference notes
- Change history

Authoring-operation rules belong in the common work-guidelines document. Keep `Design.html` centered on game content and decision rationale.
{: .article-note }

## Sample files {#samples}

Samples are rolling references, not fixed projects. They should be updated to the most recently edited and validated live document that applied the shared rules. ImageStudio and Overlord are historical seeds; after the rules propagate to later documents, more recent live documents become the next samples.

**Rolling Design sample:** new `Design.html` work should first inspect the current project document, then use the most recently edited and validated live `Design.html` as a reference.

Historical seed: `H:\Overlord\Design.html`<br>
Snapshot: `samples\Overlord.Design.sample.html`

Snapshots are references for this review document. Real project work must always reopen the latest live file and recent edited documents.

## Skills {#skills}

- The `Design.html` generation rules should live in a separate skill. General work should use the latest edited and validated live document as a rolling sample. `overlord-design-document` is the dedicated skill for Overlord-specific work.
- Image-work rules are handled by `image-first-art-workflow`; its user-facing review copy is `C:\Users\oojjr\Documents\Codex\GlobalReviews\image-first-art-workflow.review.html`.
- Skills should state the rolling-sample policy instead of relying on a fixed sample forever.
- Skills should make the priority between current project files, bundled samples, and memory explicit.

## Validation {#validation}

- Check `git diff --check`.
- Confirm encoding and line-ending preservation.
- Check HTML core markers and tag structure.
- Confirm that project-specific terms and domain terms that need explanation have tooltip help.
- Run project-specific build or test commands.
- Run the skill validator when changing a skill.
- Inspect the final diff for unintended broad rewrites.

## Storage locations {#files}

- Human-facing review document: `C:\Users\oojjr\Documents\Codex\GlobalReviews\guideline-design-generation.review.html`
- Image-work review document: `C:\Users\oojjr\Documents\Codex\GlobalReviews\image-first-art-workflow.review.html`
- Bundled samples: `C:\Users\oojjr\Documents\Codex\GlobalReviews\samples\`
- Planning-document router skill: `C:\Users\oojjr\.codex\skills\project-design-document-router\SKILL.md`

Standard date: 2026-06-15 KST. This document is a planning-document standard available even in projectless global chats.