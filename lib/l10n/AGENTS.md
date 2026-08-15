# lib/l10n — AGENTS.md

ARB source files, generated localizations, and the `context.l10n` extension.
Cross-cutting: any layer may import this folder.

- **May import:** only other files in `lib/l10n/`.
- **Must never import:** any other layer.
- `app_en.arb` is the template. Add a locale by adding `app_<code>.arb` with
  the same keys.
- To add a string: add the key **and** its `@key` description block, then run
  `flutter gen-l10n`.
- `generated/` is generated output but **is committed**, so a fresh clone
  builds without a codegen step. Never edit it by hand, never gitignore it.
- Consumers use `context.l10n.someKey`, never `AppLocalizations.of(context)`.
  The getter is non-nullable because `l10n.yaml` sets
  `nullable-getter: false`.
- Do not add `synthetic-package` to `l10n.yaml` — it is a deprecated no-op.
