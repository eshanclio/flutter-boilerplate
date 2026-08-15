# lib/orchestrators — AGENTS.md

One orchestrator per route. Composes view-ready state from services.

- **May import:** models, services.
- **Must never import:** **adapters** (go through a service), state, views,
  routes.
- **One per route, never shared.** A new screen means a new orchestrator.
- **No orchestrator-to-orchestrator imports.** Enforced by
  `dart run tool/check_architecture.dart`. One orchestrator composing another
  hides the real dependency from its route; compose services instead.
- Its route's `FooViewState` lives in `lib/models/`, **not here** — the view
  pattern-matches on that type and may not import `orchestrators/`. The
  orchestrator produces it; `models/` owns it. Declare it with `@freezed` so
  equality is structural — without that, Riverpod rebuilds the view on every
  assignment even when nothing changed.
- **No Flutter or UI types.** Return plain view state; the view decides how
  to render it.
- **Naming:** `TodoListOrchestrator`, `TodoListViewState`.
- **Tests:** `test/orchestrators/<name>_test.dart`, mocking the service with
  `mocktail`.
