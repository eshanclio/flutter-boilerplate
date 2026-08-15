import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoStorageAdapter extends Mock implements TodoStorageAdapter {}

void main() {
  late _MockTodoStorageAdapter adapter;
  late TodoService service;

  setUpAll(() => registerFallbackValue(<Todo>[]));

  setUp(() {
    adapter = _MockTodoStorageAdapter();
    service = TodoService(adapter);
    when(() => adapter.saveTodos(any())).thenAnswer((_) async {});
  });

  void stubLoad(List<Todo> todos) =>
      when(() => adapter.loadTodos()).thenAnswer((_) async => todos);

  List<Todo> capturedSave() =>
      verify(() => adapter.saveTodos(captureAny())).captured.single
          as List<Todo>;

  test('getTodos delegates to the adapter without saving', () async {
    stubLoad(const [Todo(id: '1', title: 'Buy milk')]);

    expect(await service.getTodos(), const [Todo(id: '1', title: 'Buy milk')]);
    verifyNever(() => adapter.saveTodos(any()));
  });

  test('addTodo appends a todo, saves, and returns the full list', () async {
    stubLoad(const [Todo(id: '1', title: 'Buy milk')]);

    final todos = await service.addTodo('Walk dog');

    expect(todos, hasLength(2));
    expect(todos.last.title, 'Walk dog');
    expect(todos.last.completed, isFalse);
    expect(capturedSave(), todos);
  });

  test('addTodo assigns a non-empty id distinct from existing todos', () async {
    stubLoad(const [Todo(id: '1', title: 'Buy milk')]);

    final todos = await service.addTodo('Walk dog');

    expect(todos.last.id, isNotEmpty);
    expect(todos.last.id, isNot('1'));
  });

  test('toggleTodo flips completed only for the matching id', () async {
    stubLoad(const [
      Todo(id: '1', title: 'Buy milk'),
      Todo(id: '2', title: 'Walk dog', completed: true),
    ]);

    final todos = await service.toggleTodo('2');

    expect(todos.firstWhere((todo) => todo.id == '1').completed, isFalse);
    expect(todos.firstWhere((todo) => todo.id == '2').completed, isFalse);
    expect(capturedSave(), todos);
  });

  test('toggleTodo on an unknown id leaves the list unchanged', () async {
    const existing = [Todo(id: '1', title: 'Buy milk')];
    stubLoad(existing);

    expect(await service.toggleTodo('missing'), existing);
  });

  test('removeTodo drops the matching id and saves', () async {
    stubLoad(const [
      Todo(id: '1', title: 'Buy milk'),
      Todo(id: '2', title: 'Walk dog'),
    ]);

    final todos = await service.removeTodo('1');

    expect(todos, const [Todo(id: '2', title: 'Walk dog')]);
    expect(capturedSave(), todos);
  });

  test('removeTodo on an unknown id leaves the list unchanged', () async {
    const existing = [Todo(id: '1', title: 'Buy milk')];
    stubLoad(existing);

    expect(await service.removeTodo('missing'), existing);
  });
}
