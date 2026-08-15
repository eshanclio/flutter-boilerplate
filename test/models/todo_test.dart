import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('two Todos with the same fields are equal', () {
    const a = Todo(id: '1', title: 'Buy milk');
    const b = Todo(id: '1', title: 'Buy milk');
    expect(a, b);
    expect(a.hashCode, b.hashCode);
  });

  test('two Todos differing in any field are not equal', () {
    const base = Todo(id: '1', title: 'Buy milk');
    expect(base, isNot(const Todo(id: '2', title: 'Buy milk')));
    expect(base, isNot(const Todo(id: '1', title: 'Walk dog')));
    expect(
      base,
      isNot(const Todo(id: '1', title: 'Buy milk', completed: true)),
    );
  });

  test('completed defaults to false', () {
    const todo = Todo(id: '1', title: 'Buy milk');
    expect(todo.completed, isFalse);
  });

  test('copyWith overrides only the given fields', () {
    const todo = Todo(id: '1', title: 'Buy milk');
    final toggled = todo.copyWith(completed: true);
    expect(toggled.id, '1');
    expect(toggled.title, 'Buy milk');
    expect(toggled.completed, isTrue);
  });

  test('lists of equal Todos compare equal, so view state can be compared', () {
    expect(
      const [Todo(id: '1', title: 'Buy milk')],
      const [Todo(id: '1', title: 'Buy milk')],
    );
  });
}
