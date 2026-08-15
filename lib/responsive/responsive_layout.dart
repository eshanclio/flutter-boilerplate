import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/responsive/breakpoints.dart';

/// Renders a different widget per [AppBreakpoint]. `tablet` and `desktop` fall
/// back to the next-smaller definition when omitted, so callers only supply
/// the breakpoints where the layout actually changes.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    return switch (context.breakpoint) {
      AppBreakpoint.desktop => (desktop ?? tablet ?? mobile)(context),
      AppBreakpoint.tablet => (tablet ?? mobile)(context),
      AppBreakpoint.mobile => mobile(context),
    };
  }
}
