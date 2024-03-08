// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_cache.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserCache _$UserCacheFromJson(Map<String, dynamic> json) {
  return _UserCache.fromJson(json);
}

/// @nodoc
mixin _$UserCache {
  String get userId => throw _privateConstructorUsedError;
  String get host => throw _privateConstructorUsedError;
  Map<String, UserLite> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCacheCopyWith<UserCache> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCacheCopyWith<$Res> {
  factory $UserCacheCopyWith(UserCache value, $Res Function(UserCache) then) =
      _$UserCacheCopyWithImpl<$Res, UserCache>;
  @useResult
  $Res call({String userId, String host, Map<String, UserLite> users});
}

/// @nodoc
class _$UserCacheCopyWithImpl<$Res, $Val extends UserCache>
    implements $UserCacheCopyWith<$Res> {
  _$UserCacheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? host = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<String, UserLite>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserCacheImplCopyWith<$Res>
    implements $UserCacheCopyWith<$Res> {
  factory _$$UserCacheImplCopyWith(
          _$UserCacheImpl value, $Res Function(_$UserCacheImpl) then) =
      __$$UserCacheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId, String host, Map<String, UserLite> users});
}

/// @nodoc
class __$$UserCacheImplCopyWithImpl<$Res>
    extends _$UserCacheCopyWithImpl<$Res, _$UserCacheImpl>
    implements _$$UserCacheImplCopyWith<$Res> {
  __$$UserCacheImplCopyWithImpl(
      _$UserCacheImpl _value, $Res Function(_$UserCacheImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? host = null,
    Object? users = null,
  }) {
    return _then(_$UserCacheImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      host: null == host
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as Map<String, UserLite>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCacheImpl extends _UserCache {
  const _$UserCacheImpl(
      {required this.userId, required this.host, required this.users})
      : super._();

  factory _$UserCacheImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCacheImplFromJson(json);

  @override
  final String userId;
  @override
  final String host;
  @override
  final Map<String, UserLite> users;

  @override
  String toString() {
    return 'UserCache(userId: $userId, host: $host, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCacheImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.host, host) || other.host == host) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, host, const DeepCollectionEquality().hash(users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCacheImplCopyWith<_$UserCacheImpl> get copyWith =>
      __$$UserCacheImplCopyWithImpl<_$UserCacheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCacheImplToJson(
      this,
    );
  }
}

abstract class _UserCache extends UserCache {
  const factory _UserCache(
      {required final String userId,
      required final String host,
      required final Map<String, UserLite> users}) = _$UserCacheImpl;
  const _UserCache._() : super._();

  factory _UserCache.fromJson(Map<String, dynamic> json) =
      _$UserCacheImpl.fromJson;

  @override
  String get userId;
  @override
  String get host;
  @override
  Map<String, UserLite> get users;
  @override
  @JsonKey(ignore: true)
  _$$UserCacheImplCopyWith<_$UserCacheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
