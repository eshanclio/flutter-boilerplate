# flutter_boilerplate

A Flutter **web** boilerplate with a strictly layered, DDD-inspired
architecture, wired for state management, theming, i18n, responsiveness, and
testing out of the box.

## Getting started

```bash
flutter pub get
flutter run -d chrome
```

Generated code is committed, so no codegen step is needed on a fresh clone.

## What's included

| Concern | Choice |
|---|---|
| State management | Riverpod with code generation (`@riverpod`) |
| Value classes | freezed |
| Routing | go_router, one file per route |
| i18n | ARB files + `gen-l10n`, accessed via `context.l10n` |
| Theming | Material 3 `ThemeData` built from design tokens |
| Responsiveness | `AppBreakpoint` + `ResponsiveLayout` |
| Linting | `flutter_lints`, strict analyzer flags, `riverpod_lint` |
| Architecture | enforced by `tool/check_architecture.dart` |
| Testing | unit, provider, widget, golden, integration |
| CI | GitHub Actions |

## Architecture

Dependencies flow in one direction only:

```
main -> routes -> views -> state -> orchestrators -> services -> adapters -> models
```

with `theme/`, `responsive/`, and `l10n/` as cross-cutting folders any layer
may import.

| Layer | Responsibility |
|---|---|
| `models/` | Immutable value objects |
| `adapters/` | The boundary to storage, a database, or a network service |
| `services/` | Business logic; calls adapters, never another service |
| `orchestrators/` | One per route; composes view-ready state from services |
| `state/` | Riverpod providers; thin, delegate to orchestrators |
| `views/` | Screens and their components |
| `routes/` | go_router route definitions |

This is not a convention you are trusted to remember —
`dart run tool/check_architecture.dart` parses every import and fails the
build on a violation. It runs in CI.

**`AGENTS.md` is the working contract.** The root file documents every rule
and command; each layer folder has its own with that layer's specifics. Read
them before changing code, whether you are a person or an agent.

## Example feature

A Todo list demonstrates every layer end to end — model, adapter, service,
orchestrator, provider, view with components, and route — with a test at each
level. Storage is in-memory, so todos reset on reload; swapping in
`shared_preferences` or a backend is a one-file change behind
`TodoStorageAdapter`.

## Commands

```bash
flutter test --exclude-tags golden                  # all tests except goldens
flutter test --tags golden                          # golden tests
flutter test --update-goldens --tags golden         # after an intended visual change
dart run build_runner build --delete-conflicting-outputs   # freezed + riverpod
flutter gen-l10n                                    # after editing ARB files
dart run tool/check_architecture.dart               # layer boundaries
dart analyze                                        # includes riverpod_lint
dart format .
flutter build web
```

Golden tests are excluded from CI because golden images do not reproduce
byte-for-byte across operating systems. They are a local visual check.

Web integration tests need `chromedriver`:

```bash
npx --yes @puppeteer/browsers install chromedriver@stable
chromedriver --port=4444 &
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/todo_flow_test.dart \
  -d web-server
```

## Adding a platform

Only web is enabled. All layout code is platform-agnostic, so adding a target
is enabling the platform, not rewriting UI:

```bash
flutter create --platforms=ios,android .
```

## Design documents

- Spec: `docs/superpowers/specs/2026-08-13-flutter-boilerplate-ddd-design.md`
- Implementation plan: `docs/superpowers/plans/2026-08-13-flutter-ddd-boilerplate.md`
