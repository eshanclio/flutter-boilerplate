// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_list_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodoListViewState {

 List<Todo> get todos;
/// Create a copy of TodoListViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoListViewStateCopyWith<TodoListViewState> get copyWith => _$TodoListViewStateCopyWithImpl<TodoListViewState>(this as TodoListViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoListViewState&&const DeepCollectionEquality().equals(other.todos, todos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(todos));

@override
String toString() {
  return 'TodoListViewState(todos: $todos)';
}


}

/// @nodoc
abstract mixin class $TodoListViewStateCopyWith<$Res>  {
  factory $TodoListViewStateCopyWith(TodoListViewState value, $Res Function(TodoListViewState) _then) = _$TodoListViewStateCopyWithImpl;
@useResult
$Res call({
 List<Todo> todos
});




}
/// @nodoc
class _$TodoListViewStateCopyWithImpl<$Res>
    implements $TodoListViewStateCopyWith<$Res> {
  _$TodoListViewStateCopyWithImpl(this._self, this._then);

  final TodoListViewState _self;
  final $Res Function(TodoListViewState) _then;

/// Create a copy of TodoListViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todos = null,}) {
  return _then(TodoListViewState(
todos: null == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as List<Todo>,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoListViewState].
extension TodoListViewStatePatterns on TodoListViewState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TodoListViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TodoListViewState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TodoListViewState value)  $default,){
final _that = this;
switch (_that) {
case _TodoListViewState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TodoListViewState value)?  $default,){
final _that = this;
switch (_that) {
case _TodoListViewState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Todo> todos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TodoListViewState() when $default != null:
return $default(_that.todos);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Todo> todos)  $default,) {final _that = this;
switch (_that) {
case _TodoListViewState():
return $default(_that.todos);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Todo> todos)?  $default,) {final _that = this;
switch (_that) {
case _TodoListViewState() when $default != null:
return $default(_that.todos);case _:
  return null;

}
}

}

/// @nodoc


class _TodoListViewState implements TodoListViewState {
  const _TodoListViewState({required  List<Todo> todos}): _todos = todos;
  

 final  List<Todo> _todos;
@override List<Todo> get todos {
  if (_todos is EqualUnmodifiableListView) return _todos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todos);
}


/// Create a copy of TodoListViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TodoListViewStateCopyWith<_TodoListViewState> get copyWith => __$TodoListViewStateCopyWithImpl<_TodoListViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TodoListViewState&&const DeepCollectionEquality().equals(other._todos, _todos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todos));

@override
String toString() {
  return 'TodoListViewState(todos: $todos)';
}


}

/// @nodoc
abstract mixin class _$TodoListViewStateCopyWith<$Res> implements $TodoListViewStateCopyWith<$Res> {
  factory _$TodoListViewStateCopyWith(_TodoListViewState value, $Res Function(_TodoListViewState) _then) = __$TodoListViewStateCopyWithImpl;
@override @useResult
$Res call({
 List<Todo> todos
});




}
/// @nodoc
class __$TodoListViewStateCopyWithImpl<$Res>
    implements _$TodoListViewStateCopyWith<$Res> {
  __$TodoListViewStateCopyWithImpl(this._self, this._then);

  final _TodoListViewState _self;
  final $Res Function(_TodoListViewState) _then;

/// Create a copy of TodoListViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todos = null,}) {
  return _then(_TodoListViewState(
todos: null == todos ? _self._todos : todos // ignore: cast_nullable_to_non_nullable
as List<Todo>,
  ));
}


}

// dart format on
