import 'package:flutter_boilerplate/models/todo.dart';

/// The boundary to wherever todos are persisted. Callers depend on this
/// abstraction, so swapping [InMemoryTodoStorageAdapter] for a
/// `shared_preferences`- or network-backed implementation is a one-file
/// change that touches no other layer.
abstract class TodoStorageAdapter {
  Future<List<Todo>> loadTodos();

  Future<void> saveTodos(List<Todo> todos);
}

/// In-memory implementation. Data is lost on reload; it exists so the
/// boilerplate's example feature runs with zero external setup.
class InMemoryTodoStorageAdapter implements TodoStorageAdapter {
  final List<Todo> _store = [];

  @override
  Future<List<Todo>> loadTodos() async => List.unmodifiable(_store);

  @override
  Future<void> saveTodos(List<Todo> todos) async {
    // Copy rather than retain the caller's list, so later mutation of it
    // cannot reach into storage.
    _store
      ..clear()
      ..addAll(todos);
  }
}
