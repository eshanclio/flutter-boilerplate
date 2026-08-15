import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/models/todo_list_view_state.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_boilerplate/state/todo_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoStorageAdapter extends Mock implements TodoStorageAdapter {}

void main() {
  setUpAll(() => registerFallbackValue(<Todo>[]));

  // A fresh container per test, so the in-memory adapter never leaks state
  // between tests. ProviderContainer.test() disposes itself at test end.
  ProviderContainer container({List<Override> overrides = const []}) =>
      ProviderContainer.test(overrides: overrides);

  Future<TodoListViewState> settled(ProviderContainer c) =>
      c.read(todoListNotifierProvider.future);

  TodoListViewState current(ProviderContainer c) =>
      c.read(todoListNotifierProvider).requireValue;

  test('starts empty and not loading once the future settles', () async {
    final c = container();

    final state = await settled(c);

    expect(state.todos, isEmpty);
  });

  test('addTodo appends a todo', () async {
    final c = container();
    await settled(c);

    await c.read(todoListNotifierProvider.notifier).addTodo('Buy milk');

    expect(current(c).todos.single.title, 'Buy milk');
  });

  test('toggleTodo flips completed for the given id', () async {
    final c = container();
    await settled(c);
    final notifier = c.read(todoListNotifierProvider.notifier);
    await notifier.addTodo('Buy milk');

    await notifier.toggleTodo(current(c).todos.single.id);

    expect(current(c).todos.single.completed, isTrue);
  });

  test('removeTodo removes the given id', () async {
    final c = container();
    await settled(c);
    final notifier = c.read(todoListNotifierProvider.notifier);
    await notifier.addTodo('Buy milk');

    await notifier.removeTodo(current(c).todos.single.id);

    expect(current(c).todos, isEmpty);
  });

  test(
    'each container gets its own storage, so tests do not leak state',
    () async {
      final first = container();
      await settled(first);
      await first.read(todoListNotifierProvider.notifier).addTodo('Buy milk');

      final second = container();

      expect((await settled(second)).todos, isEmpty);
    },
  );

  test('overriding the adapter provider replaces storage entirely', () async {
    final adapter = _MockTodoStorageAdapter();
    when(() => adapter.loadTodos())
        .thenAnswer((_) async => const [Todo(id: 'seeded', title: 'Seeded')]);
    when(() => adapter.saveTodos(any())).thenAnswer((_) async {});

    final c = container(
      overrides: [todoStorageAdapterProvider.overrideWithValue(adapter)],
    );

    expect((await settled(c)).todos, const [
      Todo(id: 'seeded', title: 'Seeded'),
    ]);
  });

  test('a storage failure surfaces as an error state', () async {
    final adapter = _MockTodoStorageAdapter();
    when(() => adapter.loadTodos()).thenThrow(Exception('storage down'));

    final c = container(
      overrides: [todoStorageAdapterProvider.overrideWithValue(adapter)],
    );

    await expectLater(settled(c), throwsException);
    expect(c.read(todoListNotifierProvider).hasError, isTrue);
  });
}
