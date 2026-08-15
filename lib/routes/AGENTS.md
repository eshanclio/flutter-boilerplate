# lib/routes — AGENTS.md

go_router route definitions and the router that aggregates them.

- **May import:** views, models, theme, responsive, l10n.
- **Must never import:** adapters, services, orchestrators.
- **One file per route,** holding only its path, name, and the view it
  builds. `app_router.dart` assembles them into a single `GoRouter`. Keeping
  them separate is what makes "one orchestrator per route" countable.
- **No business logic and no state.** Redirects and guards read from
  `state/` providers via the router's `ref`.
- **Naming:** `TodoListRoute` with `static const path` and `static const
  name`. Reference routes by name, never by a duplicated path literal.
- **Tests:** covered by `test/main_test.dart` and the integration test; a
  route file with no logic needs no dedicated unit test.
