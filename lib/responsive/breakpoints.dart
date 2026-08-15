import 'package:flutter/widgets.dart';

/// Named layout breakpoints. Each threshold is the minimum width, inclusive,
/// at which that breakpoint applies.
enum AppBreakpoint {
  mobile,
  tablet,
  desktop;

  static const double tabletMinWidth = 600;
  static const double desktopMinWidth = 1024;

  /// Pure resolution from a width, so breakpoint behaviour is unit-testable
  /// without pumping a widget.
  static AppBreakpoint fromWidth(double width) {
    if (width >= desktopMinWidth) return desktop;
    if (width >= tabletMinWidth) return tablet;
    return mobile;
  }
}

extension AppBreakpointContext on BuildContext {
  /// The [AppBreakpoint] matching this context's current width.
  AppBreakpoint get breakpoint {
    final width = MediaQuery.sizeOf(this).width;
    return AppBreakpoint.fromWidth(width);
  }
}
