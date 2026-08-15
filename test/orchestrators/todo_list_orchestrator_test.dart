import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/orchestrators/todo_list_orchestrator.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTodoService extends Mock implements TodoService {}

void main() {
  late _MockTodoService service;
  late TodoListOrchestrator orchestrator;

  setUp(() {
    service = _MockTodoService();
    orchestrator = TodoListOrchestrator(service);
  });

  test('loadTodos returns a settled state with the service\'s todos', () async {
    when(() => service.getTodos())
        .thenAnswer((_) async => const [Todo(id: '1', title: 'Buy milk')]);

    final state = await orchestrator.loadTodos();

    expect(state.todos, const [Todo(id: '1', title: 'Buy milk')]);
  });

  test(
    'addTodo delegates to the service and returns a settled state',
    () async {
      when(() => service.addTodo('Walk dog'))
          .thenAnswer((_) async => const [Todo(id: '1', title: 'Walk dog')]);

      final state = await orchestrator.addTodo('Walk dog');

      expect(state.todos, const [Todo(id: '1', title: 'Walk dog')]);
      verify(() => service.addTodo('Walk dog')).called(1);
    },
  );

  test('toggleTodo delegates to the service', () async {
    when(() => service.toggleTodo('1')).thenAnswer(
      (_) async => const [Todo(id: '1', title: 'Walk dog', completed: true)],
    );

    final state = await orchestrator.toggleTodo('1');

    expect(state.todos.single.completed, isTrue);
    verify(() => service.toggleTodo('1')).called(1);
  });

  test('removeTodo delegates to the service', () async {
    when(() => service.removeTodo('1')).thenAnswer((_) async => const []);

    final state = await orchestrator.removeTodo('1');

    expect(state.todos, isEmpty);
    verify(() => service.removeTodo('1')).called(1);
  });

  test('a service failure propagates rather than being swallowed', () async {
    when(() => service.getTodos()).thenThrow(Exception('storage down'));

    await expectLater(orchestrator.loadTodos(), throwsException);
  });
}
