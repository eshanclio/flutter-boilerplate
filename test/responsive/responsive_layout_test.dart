import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/responsive/responsive_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget subject({bool withTablet = false, bool withDesktop = false}) {
    return MaterialApp(
      home: ResponsiveLayout(
        mobile: (_) => const Text('mobile'),
        tablet: withTablet ? (_) => const Text('tablet') : null,
        desktop: withDesktop ? (_) => const Text('desktop') : null,
      ),
    );
  }

  Future<void> pumpAt(WidgetTester tester, Size size, Widget widget) async {
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(widget);
  }

  testWidgets('renders each builder at its own breakpoint', (tester) async {
    final widget = subject(withTablet: true, withDesktop: true);

    await pumpAt(tester, const Size(400, 800), widget);
    expect(find.text('mobile'), findsOneWidget);

    await pumpAt(tester, const Size(800, 800), widget);
    expect(find.text('tablet'), findsOneWidget);

    await pumpAt(tester, const Size(1200, 800), widget);
    expect(find.text('desktop'), findsOneWidget);
  });

  testWidgets('desktop falls back to tablet when desktop is omitted', (
    tester,
  ) async {
    await pumpAt(tester, const Size(1200, 800), subject(withTablet: true));
    expect(find.text('tablet'), findsOneWidget);
  });

  testWidgets('tablet and desktop both fall back to mobile when omitted', (
    tester,
  ) async {
    await pumpAt(tester, const Size(800, 800), subject());
    expect(find.text('mobile'), findsOneWidget);

    await pumpAt(tester, const Size(1200, 800), subject());
    expect(find.text('mobile'), findsOneWidget);
  });
}
