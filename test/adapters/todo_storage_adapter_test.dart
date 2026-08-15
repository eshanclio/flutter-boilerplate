import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryTodoStorageAdapter adapter;

  setUp(() => adapter = InMemoryTodoStorageAdapter());

  test('loadTodos returns empty before anything is saved', () async {
    expect(await adapter.loadTodos(), isEmpty);
  });

  test('saveTodos then loadTodos round-trips the same todos', () async {
    const todos = [Todo(id: '1', title: 'Buy milk')];
    await adapter.saveTodos(todos);
    expect(await adapter.loadTodos(), todos);
  });

  test('saveTodos replaces the previous contents', () async {
    await adapter.saveTodos(const [Todo(id: '1', title: 'Buy milk')]);
    await adapter.saveTodos(const [Todo(id: '2', title: 'Walk dog')]);
    expect(await adapter.loadTodos(), const [Todo(id: '2', title: 'Walk dog')]);
  });

  test(
    'the returned list is unmodifiable, so callers cannot mutate storage',
    () async {
      await adapter.saveTodos(const [Todo(id: '1', title: 'Buy milk')]);
      final loaded = await adapter.loadTodos();
      expect(
        () => loaded.add(const Todo(id: '2', title: 'Walk dog')),
        throwsUnsupportedError,
      );
    },
  );

  test('mutating the saved list afterwards does not affect storage', () async {
    final source = [const Todo(id: '1', title: 'Buy milk')];
    await adapter.saveTodos(source);
    source.clear();
    expect(await adapter.loadTodos(), hasLength(1));
  });

  test('two instances do not share state', () async {
    await adapter.saveTodos(const [Todo(id: '1', title: 'Buy milk')]);
    expect(await InMemoryTodoStorageAdapter().loadTodos(), isEmpty);
  });
}
