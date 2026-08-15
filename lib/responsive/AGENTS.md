# lib/responsive — AGENTS.md

Breakpoints and layout helpers. Cross-cutting: any layer may import this
folder.

- **May import:** only other files in `lib/responsive/`.
- **Must never import:** any other layer.
- `AppBreakpoint` owns the thresholds. Never hardcode a pixel width in a
  view — add or reuse a breakpoint.
- `AppBreakpoint.fromWidth` is pure so breakpoint behaviour is unit-testable
  without pumping a widget; `context.breakpoint` is the thin wrapper over
  `MediaQuery.sizeOf`.
- `ResponsiveLayout` falls back to the next-smaller builder, so callers only
  supply the breakpoints where the layout actually changes.
- Keep everything platform-agnostic. Only web is enabled today; adding a
  platform must not require rewriting layout.
- **Tests:** `test/responsive/`.
