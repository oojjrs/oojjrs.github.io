# Design.html Rules

Read this only for `Design.html` creation, review, cleanup, or update. Keep it compact.

1. Layout is not optional. For every new, rebuilt, or heavily reorganized `Design.html`, read the mandatory layout template with `gh api -H "Accept: application/vnd.github.raw" "repos/oojjrs/mines/contents/Design.html?ref=main"`; human reference: `https://github.com/oojjrs/mines/blob/main/Design.html`.
2. Start from that template's document shell and preserve its layout system: dark header, fixed side nav, nav groups, paired `section-group` blocks, `section-group-body`, child `<details id="...">`, `summary`, `.details-body`, image filename tags, responsive rules, synchronized navigation, and image lightbox behavior.
3. Do not invent a different layout, landing page, hero, card system, color theme, navigation model, freeform Markdown-like page, or section organization. Remove Mines-specific content and assets, but keep the template structure unless the user explicitly orders a structural deviation.
4. `Design.html` is product/game planning, not chat history or a work board: keep final decisions, rationale, current implementation state, and unresolved items only.
5. Do not put workflow, queue, validation, git, approval, commit rules, shared guideline links, or other work-operation text in `Design.html`.
6. Read the live `Design.html` first; current code/assets beat stale planning text.
7. If code and planning disagree, reconcile the document to current implementation and user intent.
8. Remove stale comparisons, discarded candidates, and intermediate draft descriptions once a later/final direction exists.
9. Keep prose short. Prefer screens, assets, tables, diagrams, audio/video, previews, flows, state charts, and nearby rationale.
10. Use text only for gaps the media cannot explain and for why the decision exists; do not paste long user explanations verbatim.
11. Link images to their source files so clicks open the original size.
12. Put temporary files in `$Trash`; final document assets must use live project asset paths or `DesignAssets/...`, never ad-hoc `tmp` folders.
13. Keep only assets referenced by the current document in final document-asset folders.
14. Explain important project terms with short `?` tooltips. Ask before inventing terms, meanings, or rationale.
15. Put complete/current sections first. Generated `<details>` sections are closed by default: write `<details>`, not `<details open>`.
16. Use `open` only when the user explicitly asks or for at most one tiny top overview/current section; asset, content, backlog, risk, future, and repeated sections must stay closed.
17. Put unwritten candidates and future ideas near the end in one collapsed group.
18. Keep category criteria and rationale next to the relevant data, image, table, sound, or section; do not create a separate meta-rule section.
19. Do not start the body with document signals, authoring rules, or category summaries; start with real product/game content.
20. Use planning hierarchy: identity/goal -> loop/fun/mastery -> author intent -> world/systems/content/presentation/exceptions/open items/change notes.
21. Record rationale as: why it exists, why this option won, what problem it solves, what constraints shaped it, and what later work must preserve.
22. For new docs, consider these sections and delete irrelevant ones: direction, UX goals, systems, screens/flows/rules, decisions, rejected options, open risks, assets, change notes.
23. For game docs, consider these categories: core, world, levels, characters, rules, items/economy, quests/events, interaction/combat, presentation, UI, meta/live, unresolved/excluded.
24. Validate template adherence, links, anchors, local assets, image click-throughs, tooltips, encoding, line endings, HTML structure, `details open` count/intent, project checks, skill checks when touched, and diff scope.
