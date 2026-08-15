import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/models/todo_list_view_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'view states with equal todos are equal, so Riverpod can skip rebuilds',
    () {
      const a = TodoListViewState(
        todos: [Todo(id: '1', title: 'Buy milk')],
      );
      const b = TodoListViewState(
        todos: [Todo(id: '1', title: 'Buy milk')],
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    },
  );

  test('view states differing inside the todo list are not equal', () {
    // The list is compared element-wise, not by identity — without that,
    // Riverpod would skip rebuilds after a real change.
    expect(
      const TodoListViewState(
        todos: [Todo(id: '1', title: 'Buy milk')],
      ),
      isNot(
        const TodoListViewState(
          todos: [Todo(id: '1', title: 'Buy milk', completed: true)],
        ),
      ),
    );
    expect(
      const TodoListViewState(
        todos: [Todo(id: '1', title: 'Buy milk')],
      ),
      isNot(const TodoListViewState(todos: [])),
    );
  });
}
