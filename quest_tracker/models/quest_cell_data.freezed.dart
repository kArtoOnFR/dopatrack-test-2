// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_cell_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QuestCellData {

 String? get emoji; double? get duration; bool get isCompleted;
/// Create a copy of QuestCellData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestCellDataCopyWith<QuestCellData> get copyWith => _$QuestCellDataCopyWithImpl<QuestCellData>(this as QuestCellData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestCellData&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,emoji,duration,isCompleted);

@override
String toString() {
  return 'QuestCellData(emoji: $emoji, duration: $duration, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $QuestCellDataCopyWith<$Res>  {
  factory $QuestCellDataCopyWith(QuestCellData value, $Res Function(QuestCellData) _then) = _$QuestCellDataCopyWithImpl;
@useResult
$Res call({
 String? emoji, double? duration, bool isCompleted
});




}
/// @nodoc
class _$QuestCellDataCopyWithImpl<$Res>
    implements $QuestCellDataCopyWith<$Res> {
  _$QuestCellDataCopyWithImpl(this._self, this._then);

  final QuestCellData _self;
  final $Res Function(QuestCellData) _then;

/// Create a copy of QuestCellData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? emoji = freezed,Object? duration = freezed,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestCellData].
extension QuestCellDataPatterns on QuestCellData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestCellData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestCellData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestCellData value)  $default,){
final _that = this;
switch (_that) {
case _QuestCellData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestCellData value)?  $default,){
final _that = this;
switch (_that) {
case _QuestCellData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? emoji,  double? duration,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestCellData() when $default != null:
return $default(_that.emoji,_that.duration,_that.isCompleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? emoji,  double? duration,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _QuestCellData():
return $default(_that.emoji,_that.duration,_that.isCompleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? emoji,  double? duration,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _QuestCellData() when $default != null:
return $default(_that.emoji,_that.duration,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc


class _QuestCellData implements QuestCellData {
  const _QuestCellData({this.emoji, this.duration, this.isCompleted = false});
  

@override final  String? emoji;
@override final  double? duration;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of QuestCellData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestCellDataCopyWith<_QuestCellData> get copyWith => __$QuestCellDataCopyWithImpl<_QuestCellData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestCellData&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}


@override
int get hashCode => Object.hash(runtimeType,emoji,duration,isCompleted);

@override
String toString() {
  return 'QuestCellData(emoji: $emoji, duration: $duration, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$QuestCellDataCopyWith<$Res> implements $QuestCellDataCopyWith<$Res> {
  factory _$QuestCellDataCopyWith(_QuestCellData value, $Res Function(_QuestCellData) _then) = __$QuestCellDataCopyWithImpl;
@override @useResult
$Res call({
 String? emoji, double? duration, bool isCompleted
});




}
/// @nodoc
class __$QuestCellDataCopyWithImpl<$Res>
    implements _$QuestCellDataCopyWith<$Res> {
  __$QuestCellDataCopyWithImpl(this._self, this._then);

  final _QuestCellData _self;
  final $Res Function(_QuestCellData) _then;

/// Create a copy of QuestCellData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? emoji = freezed,Object? duration = freezed,Object? isCompleted = null,}) {
  return _then(_QuestCellData(
emoji: freezed == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
