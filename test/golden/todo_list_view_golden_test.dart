@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_boilerplate/theme/app_theme.dart';
import 'package:flutter_boilerplate/views/todo_list/todo_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fixed todos with fixed ids, so the golden is deterministic — the real
/// service assigns timestamp-based ids, which would differ on every run.
class _SeededTodoStorageAdapter implements TodoStorageAdapter {
  @override
  Future<List<Todo>> loadTodos() async => const [
    Todo(id: '1', title: 'Buy milk'),
    Todo(id: '2', title: 'Walk the dog', completed: true),
    Todo(id: '3', title: 'Write the boilerplate'),
  ];

  @override
  Future<void> saveTodos(List<Todo> todos) async {}
}

void main() {
  /// Sizes via `tester.view` rather than `setSurfaceSize`: the latter only
  /// overrides layout constraints, leaving `MediaQuery.sizeOf` (and therefore
  /// `context.breakpoint`) at the default test-harness size, so the mobile
  /// golden would silently render the wide layout.
  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = size * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          todoStorageAdapterProvider.overrideWithValue(
            _SeededTodoStorageAdapter(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TodoListView(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('matches the mobile golden', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, const Size(400, 800));

    // Guards the sizing mechanism itself: `setSurfaceSize` would leave
    // MediaQuery at the harness default and render the wide layout here.
    expect(find.byKey(const Key('wideLayout')), findsNothing);

    await expectLater(
      find.byType(TodoListView),
      matchesGoldenFile('goldens/todo_list_view_mobile.png'),
    );
  });

  testWidgets('matches the desktop golden', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, const Size(1200, 900));

    expect(find.byKey(const Key('wideLayout')), findsOneWidget);

    await expectLater(
      find.byType(TodoListView),
      matchesGoldenFile('goldens/todo_list_view_desktop.png'),
    );
  });
}
