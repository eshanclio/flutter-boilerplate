# lib/adapters — AGENTS.md

The boundary to the outside world: storage, a database, a network service.

- **May import:** models.
- **Must never import:** services, orchestrators, state, views, routes.
- **One adapter per external boundary.** Declare an abstract class describing
  the boundary, then one or more concrete implementations. Callers depend on
  the abstraction so an implementation can be swapped in one file.
- **No business logic.** An adapter moves data across a boundary; it does not
  decide anything.
- **No adapter-to-adapter imports.** Enforced by
  `dart run tool/check_architecture.dart`. Each adapter owns exactly one
  boundary; if two need shared shape, that shape is a model.
- **The `@riverpod` provider for this adapter is declared in `lib/services/`,
  not here and not in `state/`** — see `todoStorageAdapterProvider` in
  `lib/services/todo_service.dart`. `state/` may not import `adapters/`, and
  `services/` is the lowest layer that already imports it legitimately.
- **Naming:** `TodoStorageAdapter`, `InMemoryTodoStorageAdapter`.
- **Tests:** `test/adapters/<name>_test.dart`, exercising a real
  implementation rather than a mock.
