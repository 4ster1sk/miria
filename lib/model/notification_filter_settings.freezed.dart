// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_filter_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationFilterSettings {
  bool get withReaction => throw _privateConstructorUsedError;
  bool get withFollow => throw _privateConstructorUsedError;
  bool get withUserNote => throw _privateConstructorUsedError;
  bool get withRenote => throw _privateConstructorUsedError;
  bool get withOther => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationFilterSettingsCopyWith<NotificationFilterSettings>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationFilterSettingsCopyWith<$Res> {
  factory $NotificationFilterSettingsCopyWith(NotificationFilterSettings value,
          $Res Function(NotificationFilterSettings) then) =
      _$NotificationFilterSettingsCopyWithImpl<$Res,
          NotificationFilterSettings>;
  @useResult
  $Res call(
      {bool withReaction,
      bool withFollow,
      bool withUserNote,
      bool withRenote,
      bool withOther});
}

/// @nodoc
class _$NotificationFilterSettingsCopyWithImpl<$Res,
        $Val extends NotificationFilterSettings>
    implements $NotificationFilterSettingsCopyWith<$Res> {
  _$NotificationFilterSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? withReaction = null,
    Object? withFollow = null,
    Object? withUserNote = null,
    Object? withRenote = null,
    Object? withOther = null,
  }) {
    return _then(_value.copyWith(
      withReaction: null == withReaction
          ? _value.withReaction
          : withReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      withFollow: null == withFollow
          ? _value.withFollow
          : withFollow // ignore: cast_nullable_to_non_nullable
              as bool,
      withUserNote: null == withUserNote
          ? _value.withUserNote
          : withUserNote // ignore: cast_nullable_to_non_nullable
              as bool,
      withRenote: null == withRenote
          ? _value.withRenote
          : withRenote // ignore: cast_nullable_to_non_nullable
              as bool,
      withOther: null == withOther
          ? _value.withOther
          : withOther // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationFilterSettingsImplCopyWith<$Res>
    implements $NotificationFilterSettingsCopyWith<$Res> {
  factory _$$NotificationFilterSettingsImplCopyWith(
          _$NotificationFilterSettingsImpl value,
          $Res Function(_$NotificationFilterSettingsImpl) then) =
      __$$NotificationFilterSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool withReaction,
      bool withFollow,
      bool withUserNote,
      bool withRenote,
      bool withOther});
}

/// @nodoc
class __$$NotificationFilterSettingsImplCopyWithImpl<$Res>
    extends _$NotificationFilterSettingsCopyWithImpl<$Res,
        _$NotificationFilterSettingsImpl>
    implements _$$NotificationFilterSettingsImplCopyWith<$Res> {
  __$$NotificationFilterSettingsImplCopyWithImpl(
      _$NotificationFilterSettingsImpl _value,
      $Res Function(_$NotificationFilterSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? withReaction = null,
    Object? withFollow = null,
    Object? withUserNote = null,
    Object? withRenote = null,
    Object? withOther = null,
  }) {
    return _then(_$NotificationFilterSettingsImpl(
      withReaction: null == withReaction
          ? _value.withReaction
          : withReaction // ignore: cast_nullable_to_non_nullable
              as bool,
      withFollow: null == withFollow
          ? _value.withFollow
          : withFollow // ignore: cast_nullable_to_non_nullable
              as bool,
      withUserNote: null == withUserNote
          ? _value.withUserNote
          : withUserNote // ignore: cast_nullable_to_non_nullable
              as bool,
      withRenote: null == withRenote
          ? _value.withRenote
          : withRenote // ignore: cast_nullable_to_non_nullable
              as bool,
      withOther: null == withOther
          ? _value.withOther
          : withOther // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$NotificationFilterSettingsImpl extends _NotificationFilterSettings {
  const _$NotificationFilterSettingsImpl(
      {this.withReaction = true,
      this.withFollow = true,
      this.withUserNote = true,
      this.withRenote = true,
      this.withOther = true})
      : super._();

  @override
  @JsonKey()
  final bool withReaction;
  @override
  @JsonKey()
  final bool withFollow;
  @override
  @JsonKey()
  final bool withUserNote;
  @override
  @JsonKey()
  final bool withRenote;
  @override
  @JsonKey()
  final bool withOther;

  @override
  String toString() {
    return 'NotificationFilterSettings(withReaction: $withReaction, withFollow: $withFollow, withUserNote: $withUserNote, withRenote: $withRenote, withOther: $withOther)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationFilterSettingsImpl &&
            (identical(other.withReaction, withReaction) ||
                other.withReaction == withReaction) &&
            (identical(other.withFollow, withFollow) ||
                other.withFollow == withFollow) &&
            (identical(other.withUserNote, withUserNote) ||
                other.withUserNote == withUserNote) &&
            (identical(other.withRenote, withRenote) ||
                other.withRenote == withRenote) &&
            (identical(other.withOther, withOther) ||
                other.withOther == withOther));
  }

  @override
  int get hashCode => Object.hash(runtimeType, withReaction, withFollow,
      withUserNote, withRenote, withOther);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationFilterSettingsImplCopyWith<_$NotificationFilterSettingsImpl>
      get copyWith => __$$NotificationFilterSettingsImplCopyWithImpl<
          _$NotificationFilterSettingsImpl>(this, _$identity);
}

abstract class _NotificationFilterSettings extends NotificationFilterSettings {
  const factory _NotificationFilterSettings(
      {final bool withReaction,
      final bool withFollow,
      final bool withUserNote,
      final bool withRenote,
      final bool withOther}) = _$NotificationFilterSettingsImpl;
  const _NotificationFilterSettings._() : super._();

  @override
  bool get withReaction;
  @override
  bool get withFollow;
  @override
  bool get withUserNote;
  @override
  bool get withRenote;
  @override
  bool get withOther;
  @override
  @JsonKey(ignore: true)
  _$$NotificationFilterSettingsImplCopyWith<_$NotificationFilterSettingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
