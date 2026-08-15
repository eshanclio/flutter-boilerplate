import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/models/todo_list_view_state.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';

/// One orchestrator per route. Calls [TodoService] only, and composes a
/// view-ready [TodoListViewState] for the todo list route's provider.
///
/// Errors are deliberately not caught here — the provider layer decides how
/// to surface them.
class TodoListOrchestrator {
  TodoListOrchestrator(this._service);

  final TodoService _service;

  Future<TodoListViewState> loadTodos() async =>
      _settled(await _service.getTodos());

  Future<TodoListViewState> addTodo(String title) async =>
      _settled(await _service.addTodo(title));

  Future<TodoListViewState> toggleTodo(String id) async =>
      _settled(await _service.toggleTodo(id));

  Future<TodoListViewState> removeTodo(String id) async =>
      _settled(await _service.removeTodo(id));

  TodoListViewState _settled(List<Todo> todos) =>
      TodoListViewState(todos: todos);
}
