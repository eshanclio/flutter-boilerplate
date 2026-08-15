# lib/theme — AGENTS.md

Design tokens and the `ThemeData` built from them. Cross-cutting: any layer
may import this folder.

- **May import:** only other files in `lib/theme/`.
- **Must never import:** any other layer.
- `tokens.dart` holds raw `const` values in `abstract final class`
  namespaces. `app_theme.dart` turns them into light and dark `ThemeData`.
- **Every token must be consumed** — by `app_theme.dart`, or directly by a
  view in the case of spacing and radii. Do not add unused tokens.
- Views read **colors and text styles** from `Theme.of(context)`, and
  **spacing and radii** from `AppSpacing`/`AppRadii` directly, because
  Flutter has no theme channel for those.
- **Tests:** `test/theme/app_theme_test.dart`.
