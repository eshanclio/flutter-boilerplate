import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_boilerplate/views/todo_list/components/todo_item_tile.dart';
import 'package:flutter_boilerplate/views/todo_list/todo_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoStorageAdapter extends Mock implements TodoStorageAdapter {}

void main() {
  setUpAll(() => registerFallbackValue(<Todo>[]));

  Widget wrap({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TodoListView(),
      ),
    );
  }

  Future<void> pumpAt(WidgetTester tester, Size size, Widget widget) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  const mobile = Size(400, 800);
  const tablet = Size(800, 900);
  const desktop = Size(1200, 900);

  testWidgets('shows the title, input hint, and empty state with no todos', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, mobile, wrap());

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.todoListTitle), findsOneWidget);
    expect(find.text(l10n.addTodoHint), findsOneWidget);
    expect(find.text(l10n.todoListEmpty), findsOneWidget);
  });

  testWidgets('adding a todo shows it and clears the field', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, mobile, wrap());

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      isEmpty,
    );
  });

  testWidgets('whitespace-only input does not add a todo', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, mobile, wrap());

    await tester.enterText(find.byType(TextField), '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(TodoItemTile), findsNothing);
  });

  testWidgets('tapping the checkbox marks a todo completed', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, mobile, wrap());

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('tapping delete removes a todo', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    await pumpAt(tester, mobile, wrap());

    await tester.enterText(find.byType(TextField), 'Buy milk');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(TodoItemTile), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.byType(TodoItemTile), findsNothing);
  });

  testWidgets('renders seeded todos from an overridden adapter', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    final adapter = _MockTodoStorageAdapter();
    when(() => adapter.loadTodos())
        .thenAnswer((_) async => const [Todo(id: '1', title: 'Seeded todo')]);
    when(() => adapter.saveTodos(any())).thenAnswer((_) async {});

    await pumpAt(
      tester,
      mobile,
      wrap(overrides: [todoStorageAdapterProvider.overrideWithValue(adapter)]),
    );

    expect(find.text('Seeded todo'), findsOneWidget);
  });

  testWidgets('shows localized error copy when storage fails', (tester) async {
    addTearDown(tester.view.resetPhysicalSize);
    final adapter = _MockTodoStorageAdapter();
    when(() => adapter.loadTodos()).thenThrow(Exception('storage down'));

    await pumpAt(
      tester,
      mobile,
      wrap(overrides: [todoStorageAdapterProvider.overrideWithValue(adapter)]),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.errorGeneric), findsOneWidget);
  });

  testWidgets('shows a snackbar when a mutation fails, keeping the list', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);
    final adapter = _MockTodoStorageAdapter();
    when(() => adapter.loadTodos())
        .thenAnswer((_) async => const [Todo(id: '1', title: 'Seeded todo')]);
    when(() => adapter.saveTodos(any())).thenThrow(Exception('storage down'));

    await pumpAt(
      tester,
      mobile,
      wrap(overrides: [todoStorageAdapterProvider.overrideWithValue(adapter)]),
    );
    expect(find.text('Seeded todo'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(l10n.errorGeneric), findsOneWidget);
    // The failed mutation must not have blown away the loaded list.
    expect(find.text('Seeded todo'), findsOneWidget);
  });

  testWidgets('constrains its width at tablet and desktop but not on mobile', (
    tester,
  ) async {
    addTearDown(tester.view.resetPhysicalSize);

    await pumpAt(tester, mobile, wrap());
    expect(find.byKey(const Key('wideLayout')), findsNothing);

    // Tablet is the interesting third case: it has no builder of its own and
    // must fall back to the wide layout rather than to mobile.
    await pumpAt(tester, tablet, wrap());
    expect(find.byKey(const Key('wideLayout')), findsOneWidget);

    await pumpAt(tester, desktop, wrap());
    expect(find.byKey(const Key('wideLayout')), findsOneWidget);
  });
}
