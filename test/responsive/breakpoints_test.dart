import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/responsive/breakpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppBreakpoint.fromWidth', () {
    test('resolves mobile below the tablet threshold', () {
      expect(AppBreakpoint.fromWidth(0), AppBreakpoint.mobile);
      expect(AppBreakpoint.fromWidth(599.9), AppBreakpoint.mobile);
    });

    test('resolves tablet at and above the tablet threshold', () {
      expect(AppBreakpoint.fromWidth(600), AppBreakpoint.tablet);
      expect(AppBreakpoint.fromWidth(1023.9), AppBreakpoint.tablet);
    });

    test('resolves desktop at and above the desktop threshold', () {
      expect(AppBreakpoint.fromWidth(1024), AppBreakpoint.desktop);
      expect(AppBreakpoint.fromWidth(3840), AppBreakpoint.desktop);
    });
  });

  testWidgets('context.breakpoint reads the current media width', (
    tester,
  ) async {
    late AppBreakpoint resolved;

    Future<void> pumpAt(Size size) async {
      // PhysicalSize is physical pixels, so we need to multiply by device pixel ratio
      tester.view.physicalSize = size * tester.view.devicePixelRatio;
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolved = context.breakpoint;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    }

    await pumpAt(const Size(400, 800));
    expect(resolved, AppBreakpoint.mobile);

    await pumpAt(const Size(800, 800));
    expect(resolved, AppBreakpoint.tablet);

    await pumpAt(const Size(1200, 800));
    expect(resolved, AppBreakpoint.desktop);
  });
}
