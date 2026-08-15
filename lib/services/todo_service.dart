import 'package:flutter_boilerplate/adapters/todo_storage_adapter.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ignore: unnecessary_import
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_service.g.dart';

/// The storage boundary. Override this in tests, or swap the implementation
/// here to change how todos persist.
@riverpod
TodoStorageAdapter todoStorageAdapter(Ref ref) => InMemoryTodoStorageAdapter();

/// Business logic for managing todos. Calls [TodoStorageAdapter] only — never
/// another service.
///
/// Every mutating method returns the full updated list, so callers never need
/// a second read to learn the new state.
class TodoService {
  TodoService(this._adapter);

  final TodoStorageAdapter _adapter;

  Future<List<Todo>> getTodos() => _adapter.loadTodos();

  Future<List<Todo>> addTodo(String title) async {
    final todos = await _adapter.loadTodos();
    final updated = [...todos, Todo(id: _generateId(), title: title)];
    await _adapter.saveTodos(updated);
    return updated;
  }

  Future<List<Todo>> toggleTodo(String id) async {
    final todos = await _adapter.loadTodos();
    final updated = [
      for (final todo in todos)
        if (todo.id == id) todo.copyWith(completed: !todo.completed) else todo,
    ];
    await _adapter.saveTodos(updated);
    return updated;
  }

  Future<List<Todo>> removeTodo(String id) async {
    final todos = await _adapter.loadTodos();
    final updated = todos.where((todo) => todo.id != id).toList();
    await _adapter.saveTodos(updated);
    return updated;
  }

  /// Microsecond timestamps are unique enough for a single-user, in-memory
  /// example. A real backend would assign ids instead.
  String _generateId() => DateTime.now().microsecondsSinceEpoch.toString();
}
