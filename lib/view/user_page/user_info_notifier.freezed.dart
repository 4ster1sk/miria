// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserInfo {
  String get userId => throw _privateConstructorUsedError;
  UserDetailed get response => throw _privateConstructorUsedError;
  String? get remoteUserId => throw _privateConstructorUsedError;
  UserDetailed? get remoteResponse => throw _privateConstructorUsedError;
  MetaResponse? get metaResponse => throw _privateConstructorUsedError;

  /// メモの更新中
  AsyncValue<void>? get updateMemo => throw _privateConstructorUsedError;

  /// フォロー操作中
  AsyncValue<void>? get follow => throw _privateConstructorUsedError;

  /// ミュート操作中
  AsyncValue<void>? get mute => throw _privateConstructorUsedError;

  /// リノート操作中
  AsyncValue<void>? get renoteMute => throw _privateConstructorUsedError;

  /// ブロック操作中
  AsyncValue<void>? get block => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call(
      {String userId,
      UserDetailed response,
      String? remoteUserId,
      UserDetailed? remoteResponse,
      MetaResponse? metaResponse,
      AsyncValue<void>? updateMemo,
      AsyncValue<void>? follow,
      AsyncValue<void>? mute,
      AsyncValue<void>? renoteMute,
      AsyncValue<void>? block});

  $MetaResponseCopyWith<$Res>? get metaResponse;
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? response = null,
    Object? remoteUserId = freezed,
    Object? remoteResponse = freezed,
    Object? metaResponse = freezed,
    Object? updateMemo = freezed,
    Object? follow = freezed,
    Object? mute = freezed,
    Object? renoteMute = freezed,
    Object? block = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as UserDetailed,
      remoteUserId: freezed == remoteUserId
          ? _value.remoteUserId
          : remoteUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      remoteResponse: freezed == remoteResponse
          ? _value.remoteResponse
          : remoteResponse // ignore: cast_nullable_to_non_nullable
              as UserDetailed?,
      metaResponse: freezed == metaResponse
          ? _value.metaResponse
          : metaResponse // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
      updateMemo: freezed == updateMemo
          ? _value.updateMemo
          : updateMemo // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      follow: freezed == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      mute: freezed == mute
          ? _value.mute
          : mute // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      renoteMute: freezed == renoteMute
          ? _value.renoteMute
          : renoteMute // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      block: freezed == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MetaResponseCopyWith<$Res>? get metaResponse {
    if (_value.metaResponse == null) {
      return null;
    }

    return $MetaResponseCopyWith<$Res>(_value.metaResponse!, (value) {
      return _then(_value.copyWith(metaResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
          _$UserInfoImpl value, $Res Function(_$UserInfoImpl) then) =
      __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      UserDetailed response,
      String? remoteUserId,
      UserDetailed? remoteResponse,
      MetaResponse? metaResponse,
      AsyncValue<void>? updateMemo,
      AsyncValue<void>? follow,
      AsyncValue<void>? mute,
      AsyncValue<void>? renoteMute,
      AsyncValue<void>? block});

  @override
  $MetaResponseCopyWith<$Res>? get metaResponse;
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
      _$UserInfoImpl _value, $Res Function(_$UserInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? response = null,
    Object? remoteUserId = freezed,
    Object? remoteResponse = freezed,
    Object? metaResponse = freezed,
    Object? updateMemo = freezed,
    Object? follow = freezed,
    Object? mute = freezed,
    Object? renoteMute = freezed,
    Object? block = freezed,
  }) {
    return _then(_$UserInfoImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      response: null == response
          ? _value.response
          : response // ignore: cast_nullable_to_non_nullable
              as UserDetailed,
      remoteUserId: freezed == remoteUserId
          ? _value.remoteUserId
          : remoteUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      remoteResponse: freezed == remoteResponse
          ? _value.remoteResponse
          : remoteResponse // ignore: cast_nullable_to_non_nullable
              as UserDetailed?,
      metaResponse: freezed == metaResponse
          ? _value.metaResponse
          : metaResponse // ignore: cast_nullable_to_non_nullable
              as MetaResponse?,
      updateMemo: freezed == updateMemo
          ? _value.updateMemo
          : updateMemo // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      follow: freezed == follow
          ? _value.follow
          : follow // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      mute: freezed == mute
          ? _value.mute
          : mute // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      renoteMute: freezed == renoteMute
          ? _value.renoteMute
          : renoteMute // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
      block: freezed == block
          ? _value.block
          : block // ignore: cast_nullable_to_non_nullable
              as AsyncValue<void>?,
    ));
  }
}

/// @nodoc

class _$UserInfoImpl extends _UserInfo {
  const _$UserInfoImpl(
      {required this.userId,
      required this.response,
      this.remoteUserId,
      this.remoteResponse,
      this.metaResponse,
      this.updateMemo,
      this.follow,
      this.mute,
      this.renoteMute,
      this.block})
      : super._();

  @override
  final String userId;
  @override
  final UserDetailed response;
  @override
  final String? remoteUserId;
  @override
  final UserDetailed? remoteResponse;
  @override
  final MetaResponse? metaResponse;

  /// メモの更新中
  @override
  final AsyncValue<void>? updateMemo;

  /// フォロー操作中
  @override
  final AsyncValue<void>? follow;

  /// ミュート操作中
  @override
  final AsyncValue<void>? mute;

  /// リノート操作中
  @override
  final AsyncValue<void>? renoteMute;

  /// ブロック操作中
  @override
  final AsyncValue<void>? block;

  @override
  String toString() {
    return 'UserInfo(userId: $userId, response: $response, remoteUserId: $remoteUserId, remoteResponse: $remoteResponse, metaResponse: $metaResponse, updateMemo: $updateMemo, follow: $follow, mute: $mute, renoteMute: $renoteMute, block: $block)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.response, response) ||
                other.response == response) &&
            (identical(other.remoteUserId, remoteUserId) ||
                other.remoteUserId == remoteUserId) &&
            (identical(other.remoteResponse, remoteResponse) ||
                other.remoteResponse == remoteResponse) &&
            (identical(other.metaResponse, metaResponse) ||
                other.metaResponse == metaResponse) &&
            (identical(other.updateMemo, updateMemo) ||
                other.updateMemo == updateMemo) &&
            (identical(other.follow, follow) || other.follow == follow) &&
            (identical(other.mute, mute) || other.mute == mute) &&
            (identical(other.renoteMute, renoteMute) ||
                other.renoteMute == renoteMute) &&
            (identical(other.block, block) || other.block == block));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      response,
      remoteUserId,
      remoteResponse,
      metaResponse,
      updateMemo,
      follow,
      mute,
      renoteMute,
      block);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);
}

abstract class _UserInfo extends UserInfo {
  const factory _UserInfo(
      {required final String userId,
      required final UserDetailed response,
      final String? remoteUserId,
      final UserDetailed? remoteResponse,
      final MetaResponse? metaResponse,
      final AsyncValue<void>? updateMemo,
      final AsyncValue<void>? follow,
      final AsyncValue<void>? mute,
      final AsyncValue<void>? renoteMute,
      final AsyncValue<void>? block}) = _$UserInfoImpl;
  const _UserInfo._() : super._();

  @override
  String get userId;
  @override
  UserDetailed get response;
  @override
  String? get remoteUserId;
  @override
  UserDetailed? get remoteResponse;
  @override
  MetaResponse? get metaResponse;
  @override

  /// メモの更新中
  AsyncValue<void>? get updateMemo;
  @override

  /// フォロー操作中
  AsyncValue<void>? get follow;
  @override

  /// ミュート操作中
  AsyncValue<void>? get mute;
  @override

  /// リノート操作中
  AsyncValue<void>? get renoteMute;
  @override

  /// ブロック操作中
  AsyncValue<void>? get block;
  @override
  @JsonKey(ignore: true)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}