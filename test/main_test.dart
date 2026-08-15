import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/l10n/generated/app_localizations.dart';
import 'package:flutter_boilerplate/main.dart';
import 'package:flutter_boilerplate/views/todo_list/todo_list_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots at the todo list route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.byType(TodoListView), findsOneWidget);
    expect(find.text(l10n.todoListTitle), findsOneWidget);
  });

  testWidgets('App registers localization delegates and both themes', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
    expect(app.supportedLocales, contains(const Locale('en')));
  });
}
