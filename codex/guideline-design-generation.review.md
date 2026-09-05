# Design.html Rules

Read this only for `Design.html` creation, review, cleanup, or update. Keep it compact.

1. Layout is not optional. When creating a brand-new `Design.html`, use a compact, navigable structure suited to the current project; for existing document updates, do not rebuild the layout unless the user explicitly asks.
2. When starting from a provided template, preserve its layout system: dark header, fixed side nav, nav groups, paired `section-group` blocks, `section-group-body`, child `<details id="...">`, `summary`, `.details-body`, image filename tags, responsive rules, synchronized navigation, and image lightbox behavior.
3. Do not invent a different layout, landing page, hero, card system, color theme, navigation model, freeform Markdown-like page, or section organization. When a template applies, remove template-specific content and assets, but keep the template structure unless the user explicitly orders a structural deviation.
4. `Design.html` is product/game planning, not chat history or a work board: keep final decisions, current implementation state, and unresolved items only.
5. Do not put workflow, queue, validation, git, approval, commit rules, shared guideline links, or other work-operation text in `Design.html`.
6. Read the live `Design.html` first; current code/assets beat stale planning text.
7. If code and planning disagree, reconcile the document to current implementation and user intent.
8. Remove stale comparisons, discarded candidates, and intermediate draft descriptions once a later/final direction exists.
9. Keep prose short. Prefer screens, assets, tables, diagrams, audio/video, previews, flows, and state charts.
10. Use text only for gaps the media cannot explain; do not paste long user explanations verbatim.
11. Link images to their source files so clicks open the original size.
12. Put temporary files in `$Trash`; final document assets must use live project asset paths or `DesignAssets/...`, never ad-hoc `tmp` folders.
13. Keep only assets referenced by the current document in final document-asset folders.
14. Explain important project terms with short `?` tooltips. Ask before inventing terms, meanings, or rationale.
15. Arrange sections according to the overall planning structure. Generated `<details>` sections are closed by default: write `<details>`, not `<details open>`.
16. Use `open` only when the user explicitly asks or for at most one tiny top overview/current section; asset, content, backlog, risk, future, and repeated sections must stay closed.
17. Put unwritten candidates and future ideas near the end in one collapsed group.
18. Keep category criteria next to the relevant data, image, table, sound, or section; do not create a separate meta-rule section.
19. Do not start the body with document signals, authoring rules, or category summaries; start with real product/game content.
20. Validate only changed document behavior against independent evidence: parse the changed HTML structure, resolve changed links, anchors, local asset references, and image click-throughs, and compare changed tooltips or `details open` state with the requested design. Use browser checks only when the user requests them or when layout or responsive behavior changed; then inspect only the affected desktop and mobile surfaces.
