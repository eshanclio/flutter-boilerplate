# lib/services — AGENTS.md

Business logic.

- **May import:** models, adapters.
- **Must never import:** **another service**, orchestrators, state, views,
  routes.
- **No service-to-service calls.** This is enforced by
  `dart run tool/check_architecture.dart`. If two services need the same
  logic, push it down into an adapter or up into the orchestrator that needs
  both.
- **No Flutter or UI types.** A service's own methods take and return models
  only — never `BuildContext`, widgets, or anything from `theme/`, `l10n/`, or
  `responsive/`. The one permitted exception is the provider declaration
  below, which needs `flutter_riverpod`.
- **The abstract adapter's `@riverpod` provider is declared here, not in
  `state/`.** See `todoStorageAdapterProvider` in `todo_service.dart`. It
  cannot live in `state/`, because `state/` may not import `adapters/` — and
  the provider must name the concrete implementation it returns. This layer
  already imports `adapters/` legitimately, so it is the lowest layer that
  can declare it. Override this provider in tests to swap the backing store.
- **Naming:** `TodoService`. Take dependencies as constructor parameters
  typed to the abstract adapter, never construct them internally — that is
  what makes the service testable.
- **Tests:** `test/services/<name>_test.dart`, mocking the adapter with
  `mocktail`.
