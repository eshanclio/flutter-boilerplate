# AGENTS.md

Flutter web boilerplate with a strictly layered, DDD-inspired architecture.
Read this file before adding or modifying anything under `lib/`. Each layer
folder also has its own `AGENTS.md` with that layer's rules — read the one
for the folder you are editing.

Architecture decisions and their rationale live in
`docs/superpowers/specs/2026-08-13-flutter-boilerplate-ddd-design.md`.

## Commands

| Task | Command |
|---|---|
| Install dependencies | `flutter pub get` |
| Run the app | `flutter run -d chrome` |
| Regenerate code (freezed, riverpod) | `dart run build_runner build --delete-conflicting-outputs` |
| Watch and regenerate during development | `dart run build_runner watch -d` |
| Regenerate localizations | `flutter gen-l10n` |
| Run all tests except goldens | `flutter test --exclude-tags golden` |
| Run golden tests | `flutter test --tags golden` |
| Update goldens after an intentional visual change | `flutter test --update-goldens --tags golden` |
| Check architecture boundaries | `dart run tool/check_architecture.dart` |
| Analyze (includes riverpod_lint) | `dart analyze` |
| Format | `dart format .` |
| Build for web | `flutter build web` |
| Run web integration tests | see "Integration tests" below |

## Definition of done

A change is not complete until all of these pass:

```bash
dart run tool/check_architecture.dart
dart analyze
flutter test --exclude-tags golden
dart format --output=none --set-exit-if-changed .
```

If you changed anything a generator reads, regenerate and commit the output
first — see "Generated code" below.

## Layers

Dependencies flow in one direction only:

```
main -> routes -> views -> state -> orchestrators -> services -> adapters -> models
```

`theme/`, `responsive/`, and `l10n/` are cross-cutting: any layer may import
them, and they may only import within their own folder.

| Layer | Responsibility | May import | Must never import |
|---|---|---|---|
| `lib/models/` | Immutable value objects. No I/O, no business logic. | other models | everything else |
| `lib/adapters/` | The boundary to storage, a database, or a network service. One adapter per boundary. | models | services, orchestrators, state, views, routes |
| `lib/services/` | Business logic. | models, adapters | **other services**, orchestrators, state, views, routes |
| `lib/orchestrators/` | One per route. Composes view-ready state. | models, services | **adapters**, state, views, routes |
| `lib/state/` | Riverpod providers. Thin — no business logic. | models, services, orchestrators | **adapters**, views, routes |
| `lib/views/` | Screens and their components. | models, state | adapters, services, orchestrators, **routes** |
| `lib/routes/` | go_router route definitions and the router. | views | adapters, services, orchestrators |
| `lib/main.dart` | Entrypoint. | routes, theme, l10n | everything else |

`routes/` sits above `views/` because a route's only job is to name a path
and render a view.

These rules are enforced by `dart run tool/check_architecture.dart`, which
exits non-zero listing every offending import. It runs in CI.

**What the check does and does not see.** It parses `import` and `export`
directives per file and compares layer folders, so it catches every direct
upward or forbidden import, an unrecognized folder under `lib/`, and a file
sitting loose directly in `lib/`. It cannot resolve symbols, so three things
stay a matter of discipline: re-exporting a lower layer from a higher one,
reaching a layer through a third-party package that itself re-exports it, and
the one-orchestrator-per-route rule. A green check means no illegal import
edge — not that the architecture is honoured.

## Import style

**All imports of one `lib/` file from another use the `package:` form.**

```dart
// Correct
import 'package:flutter_boilerplate/services/todo_service.dart';

// Wrong — lint error (always_use_package_imports)
import '../services/todo_service.dart';
```

Because everything is a `package:` import, each file's imports form one
alphabetically sorted block (`directives_ordering`):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/state/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

`part` directives are the one exception — they are always relative:

```dart
part 'todo.freezed.dart';
```

## Naming and file placement

| Kind | Name | File |
|---|---|---|
| Model | `Todo` — plain, **not** `TodoModel` | `lib/models/todo.dart` |
| Adapter | `TodoStorageAdapter` (+ `InMemoryTodoStorageAdapter`) | `lib/adapters/todo_storage_adapter.dart` |
| Service | `TodoService` | `lib/services/todo_service.dart` |
| Orchestrator | `TodoListOrchestrator` | `lib/orchestrators/todo_list_orchestrator.dart` |
| View state | `TodoListViewState` — lives in `models/`, not beside its orchestrator | `lib/models/todo_list_view_state.dart` |
| Provider | `todoServiceProvider`, `TodoListNotifier` | `lib/state/todo_list_provider.dart` |
| Adapter provider | `todoStorageAdapterProvider` — in `services/`, **not** `state/`, because `state/` may not import `adapters/` | `lib/services/todo_service.dart` |
| View | `TodoListView` | `lib/views/todo_list/todo_list_view.dart` |
| Component | `TodoItemTile` | `lib/views/todo_list/components/todo_item_tile.dart` |
| Route | `TodoListRoute` | `lib/routes/todo_list_route.dart` |

Tests mirror `lib/` exactly: `lib/services/todo_service.dart` →
`test/services/todo_service_test.dart`.

Tests are **never** co-located inside `lib/`. `depend_on_referenced_packages`
(part of `flutter_lints`) fails `dart analyze` when a file under `lib/`
imports a dev-only package such as `flutter_test` or `mocktail`.

## Generated code

Generated files are **committed** so a fresh clone builds and tests without
a codegen step. Never gitignore them.

| After editing | Run |
|---|---|
| A `@freezed` class | `dart run build_runner build --delete-conflicting-outputs` |
| A `@riverpod` provider or notifier | `dart run build_runner build --delete-conflicting-outputs` |
| `lib/l10n/*.arb` | `flutter gen-l10n` |

CI re-runs both and fails if the tree is dirty, so stale generated output is
caught rather than silently diverging.

## Styling

- **Colors and text styles** come from `Theme.of(context)`. Never read
  `AppColors` or `AppTypography` in a view.
- **Spacing and radii** come from `AppSpacing`/`AppRadii` directly, because
  Flutter has no theme channel for them.
- New tokens go in `lib/theme/tokens.dart` and must be consumed by
  `lib/theme/app_theme.dart` or by a view. Do not add unused tokens.

## Strings

Every user-visible string comes from ARB and is read via `context.l10n`:

```dart
Text(context.l10n.todoListTitle)
```

Never call `AppLocalizations.of(context)` directly, and never hardcode a
display string in a view — including error and empty-state copy.

To add a string: add the key and an `@key` description block to
`lib/l10n/app_en.arb`, run `flutter gen-l10n`, then use `context.l10n.yourKey`.

## Responsiveness

Use `ResponsiveLayout` when a screen needs a different layout per breakpoint,
or `context.breakpoint` for a single value that varies. Thresholds live in
`AppBreakpoint`. Only the web target is enabled, but all layout code is
platform-agnostic.

## Testing

| Layer | Test kind | Notes |
|---|---|---|
| models | unit | equality, `copyWith`, defaults |
| adapters | unit | against the real in-memory implementation |
| services | unit | mock the adapter with `mocktail` |
| orchestrators | unit | mock the service with `mocktail` |
| state | provider | `ProviderContainer.test()`, one fresh container per test |
| views | widget | pump inside a `ProviderScope`; override providers to inject doubles |
| screens | golden | tagged `golden`; excluded from Linux CI |
| whole app | integration | `integration_test/`, run via `flutter drive` |

Every new service, orchestrator, adapter, and model ships with a unit test.

Use `ProviderContainer.test()` in provider tests — it auto-disposes. Never
share a container between tests.

### Golden tests

Golden images do not reproduce byte-for-byte across operating systems, so they
are tagged `golden` and excluded from the Linux CI job. Treat a golden failure
after an intentional visual change as expected: regenerate with
`flutter test --update-goldens --tags golden` and review the `.png` diff
before committing.

### Integration tests

`integration_test` does not run under `flutter test` on web. It needs
`flutter drive` and a running `chromedriver`:

```bash
npx --yes @puppeteer/browsers install chromedriver@stable
chromedriver --port=4444 &
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/todo_flow_test.dart \
  -d web-server
```

## Adding a feature end to end

Adding a "archive todo" action touches every layer, in this order:

1. **Model** — if it needs new data, add the field to `lib/models/todo.dart`
   and regenerate. Update `test/models/todo_test.dart`.
2. **Adapter** — only if the persistence shape changes. Extend the abstract
   `TodoStorageAdapter` and every implementation.
3. **Service** — add `archiveTodo(String id)` to `TodoService`, calling the
   adapter. Add a `mocktail`-based test.
4. **Orchestrator** — add `archiveTodo` returning an updated
   `TodoListViewState`. Add a test mocking `TodoService`.
5. **State** — add a matching method to `TodoListNotifier` that delegates to
   the orchestrator and assigns `state = AsyncData(...)`. Regenerate. Add a
   `ProviderContainer.test()` test.
6. **Strings** — add ARB keys, run `flutter gen-l10n`.
7. **View** — wire a control to the notifier method. Add a widget test.
8. **Route** — only if this is a new screen: add a `lib/routes/*_route.dart`
   and register it in `app_router.dart`.
9. **Verify** — run the definition-of-done commands above.

Note the shape: a new screen means a new orchestrator, because there is one
orchestrator per route.

## Anti-patterns

Do not:

- Call an adapter from an orchestrator, a state provider, or a view. Go
  through a service.
- Call a service from another service. Move the shared logic down into an
  adapter, or up into the orchestrator that needs both.
- Call a service or orchestrator from a view. Go through `state/`.
- Put business logic in a state provider, a route, or a view. Providers
  delegate; orchestrators compose; services decide.
- Give a route more than one orchestrator, or share one orchestrator between
  routes.
- Use a relative import inside `lib/`.
- Re-export a lower layer from a higher one. `export` in `state/` of a
  `services/` file hands a view the service's symbols through a legal-looking
  import. The check inspects the import graph, so it cannot see this — the
  rule is yours to keep.
- Put a Dart file directly in `lib/`. Every file belongs to a layer folder;
  `lib/main.dart` is the only exception. A loose `lib/app_state.dart` is how
  this architecture erodes, so the check now reports it.
- Hardcode a user-visible string, a color, or a text style in a view.
- Add a token to `tokens.dart` without consuming it.
- Gitignore generated files, or commit source changes without regenerating.
- Add a package without checking it is actively maintained, and add it at its
  latest compatible version via `flutter pub add`.
- Weaken `analysis_options.yaml` to make code pass. Fix the code.
