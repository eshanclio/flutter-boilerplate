# lib/views — AGENTS.md

Screens and their components.

- **May import:** models, state, theme, responsive, l10n.
- **Must never import:** adapters, services, orchestrators (go through
  `state/`), or **routes** — a route imports a view, never the reverse.
- **Layout:** one folder per screen — `lib/views/todo_list/todo_list_view.dart`
  plus a `components/` subfolder for its pieces. A component used by more
  than one screen moves up to `lib/views/components/`.
- **No business logic.** A view reads state and dispatches actions.
- **Strings:** always `context.l10n.someKey`. Never hardcode display text,
  including empty-state and error copy.
- **Colors and text styles:** always `Theme.of(context)`. **Spacing and
  radii:** always `AppSpacing`/`AppRadii`.
- **Responsiveness:** use `ResponsiveLayout` for per-breakpoint layouts, or
  `context.breakpoint` for a single varying value.
- **Naming:** `TodoListView`, `TodoItemTile`. Prefer `ConsumerWidget` over a
  `StatefulWidget` unless local widget state is genuinely needed.
- **Tests:** `test/views/<screen>/<name>_test.dart` — pump inside a
  `ProviderScope`, override providers to inject doubles, and assert layout at
  more than one surface size when the screen is responsive.
- **Sizing a test surface:** set `tester.view.devicePixelRatio` and
  `tester.view.physicalSize`, with
  `addTearDown(tester.view.resetPhysicalSize)`. Do **not** use
  `tester.binding.setSurfaceSize` — it overrides the render view's
  constraints without touching `FlutterView.physicalSize`, which is what
  `MediaQueryData.fromView` reads, so breakpoint code never sees the size and
  the test silently asserts the wrong layout.
- **Assert the mechanism, not just the pixels.** Give each branch of a
  responsive layout a `Key` and assert it is present or absent at each size.
  A golden alone can pass while rendering the wrong branch.
