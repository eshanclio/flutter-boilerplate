# lib/models — AGENTS.md

Immutable value objects. The lowest layer.

- **May import:** other models. Nothing else under `lib/`.
- **Must never import:** adapters, services, orchestrators, state, views,
  routes, theme, responsive, l10n.
- **No I/O, no business logic, no formatting.** A model holds data and
  validates its own shape. Decisions belong in a service.
- **Naming:** plain `Todo`, not `TodoModel`.
- Use `@freezed` for equality, `copyWith`, and deep collection equality.
  After editing, run `dart run build_runner build --delete-conflicting-outputs`.
- **Tests:** `test/models/<name>_test.dart` — equality, defaults, `copyWith`.
