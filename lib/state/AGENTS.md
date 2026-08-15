# lib/state — AGENTS.md

Riverpod providers. The only layer allowed to depend on orchestrators.

- **May import:** models, services, orchestrators.
- **Must never import:** **adapters** (go through a service), views, routes.
- **Do not declare an adapter's provider here.** It needs to name a concrete
  adapter, which this layer may not import. Those providers live in
  `lib/services/` beside the service that consumes them — see
  `todoStorageAdapterProvider`.
- **Keep providers thin.** Build state from an orchestrator and delegate
  actions straight back to it. Business logic belongs in a service, and
  composition in an orchestrator.
- Use code generation: `@riverpod` plus `part '<file>.g.dart';`. After
  editing, run `dart run build_runner build --delete-conflicting-outputs`.
- Function-based providers take a plain `Ref` parameter. The generated
  `<Name>Ref` subclasses were removed in Riverpod 3.
- Import both `package:flutter_riverpod/flutter_riverpod.dart` and
  `package:riverpod_annotation/riverpod_annotation.dart`. Never depend on
  bare `riverpod`.
- In a notifier, assign `state = AsyncData(await orchestrator.doThing())`.
  Do **not** wrap mutations in `AsyncValue.guard` — a failed single action
  would render the whole screen as an error. `guard` is for the initial load
  in `build` only.
- **Mutation errors are the view's job.** A failing action is caught at the
  call site in the view and surfaced transiently (e.g. a `SnackBar`) — never
  by writing the error into provider state.
- **Naming:** `todoServiceProvider`, `TodoListNotifier` /
  `todoListNotifierProvider`.
- **Tests:** `test/state/<name>_test.dart` using `ProviderContainer.test()`,
  one fresh container per test.
