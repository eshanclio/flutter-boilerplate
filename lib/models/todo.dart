import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

/// A single todo item. Immutable value object — no I/O, no business logic.
@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;
}
