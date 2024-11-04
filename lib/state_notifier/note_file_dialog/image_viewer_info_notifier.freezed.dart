// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_viewer_info_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ImageViewerInfo {
  double get scale => throw _privateConstructorUsedError;
  double get lastScale => throw _privateConstructorUsedError;
  int get pointersCount => throw _privateConstructorUsedError;
  bool get isDoubleTap => throw _privateConstructorUsedError;
  Offset? get lastTapLocalPosition => throw _privateConstructorUsedError;

  /// Create a copy of ImageViewerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImageViewerInfoCopyWith<ImageViewerInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImageViewerInfoCopyWith<$Res> {
  factory $ImageViewerInfoCopyWith(
          ImageViewerInfo value, $Res Function(ImageViewerInfo) then) =
      _$ImageViewerInfoCopyWithImpl<$Res, ImageViewerInfo>;
  @useResult
  $Res call(
      {double scale,
      double lastScale,
      int pointersCount,
      bool isDoubleTap,
      Offset? lastTapLocalPosition});
}

/// @nodoc
class _$ImageViewerInfoCopyWithImpl<$Res, $Val extends ImageViewerInfo>
    implements $ImageViewerInfoCopyWith<$Res> {
  _$ImageViewerInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImageViewerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scale = null,
    Object? lastScale = null,
    Object? pointersCount = null,
    Object? isDoubleTap = null,
    Object? lastTapLocalPosition = freezed,
  }) {
    return _then(_value.copyWith(
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      lastScale: null == lastScale
          ? _value.lastScale
          : lastScale // ignore: cast_nullable_to_non_nullable
              as double,
      pointersCount: null == pointersCount
          ? _value.pointersCount
          : pointersCount // ignore: cast_nullable_to_non_nullable
              as int,
      isDoubleTap: null == isDoubleTap
          ? _value.isDoubleTap
          : isDoubleTap // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTapLocalPosition: freezed == lastTapLocalPosition
          ? _value.lastTapLocalPosition
          : lastTapLocalPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImageViewerInfoImplCopyWith<$Res>
    implements $ImageViewerInfoCopyWith<$Res> {
  factory _$$ImageViewerInfoImplCopyWith(_$ImageViewerInfoImpl value,
          $Res Function(_$ImageViewerInfoImpl) then) =
      __$$ImageViewerInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double scale,
      double lastScale,
      int pointersCount,
      bool isDoubleTap,
      Offset? lastTapLocalPosition});
}

/// @nodoc
class __$$ImageViewerInfoImplCopyWithImpl<$Res>
    extends _$ImageViewerInfoCopyWithImpl<$Res, _$ImageViewerInfoImpl>
    implements _$$ImageViewerInfoImplCopyWith<$Res> {
  __$$ImageViewerInfoImplCopyWithImpl(
      _$ImageViewerInfoImpl _value, $Res Function(_$ImageViewerInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of ImageViewerInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scale = null,
    Object? lastScale = null,
    Object? pointersCount = null,
    Object? isDoubleTap = null,
    Object? lastTapLocalPosition = freezed,
  }) {
    return _then(_$ImageViewerInfoImpl(
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      lastScale: null == lastScale
          ? _value.lastScale
          : lastScale // ignore: cast_nullable_to_non_nullable
              as double,
      pointersCount: null == pointersCount
          ? _value.pointersCount
          : pointersCount // ignore: cast_nullable_to_non_nullable
              as int,
      isDoubleTap: null == isDoubleTap
          ? _value.isDoubleTap
          : isDoubleTap // ignore: cast_nullable_to_non_nullable
              as bool,
      lastTapLocalPosition: freezed == lastTapLocalPosition
          ? _value.lastTapLocalPosition
          : lastTapLocalPosition // ignore: cast_nullable_to_non_nullable
              as Offset?,
    ));
  }
}

/// @nodoc

class _$ImageViewerInfoImpl implements _ImageViewerInfo {
  const _$ImageViewerInfoImpl(
      {this.scale = 1.0,
      this.lastScale = 1.0,
      this.pointersCount = 0,
      this.isDoubleTap = false,
      this.lastTapLocalPosition = null});

  @override
  @JsonKey()
  final double scale;
  @override
  @JsonKey()
  final double lastScale;
  @override
  @JsonKey()
  final int pointersCount;
  @override
  @JsonKey()
  final bool isDoubleTap;
  @override
  @JsonKey()
  final Offset? lastTapLocalPosition;

  @override
  String toString() {
    return 'ImageViewerInfo(scale: $scale, lastScale: $lastScale, pointersCount: $pointersCount, isDoubleTap: $isDoubleTap, lastTapLocalPosition: $lastTapLocalPosition)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImageViewerInfoImpl &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.lastScale, lastScale) ||
                other.lastScale == lastScale) &&
            (identical(other.pointersCount, pointersCount) ||
                other.pointersCount == pointersCount) &&
            (identical(other.isDoubleTap, isDoubleTap) ||
                other.isDoubleTap == isDoubleTap) &&
            (identical(other.lastTapLocalPosition, lastTapLocalPosition) ||
                other.lastTapLocalPosition == lastTapLocalPosition));
  }

  @override
  int get hashCode => Object.hash(runtimeType, scale, lastScale, pointersCount,
      isDoubleTap, lastTapLocalPosition);

  /// Create a copy of ImageViewerInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImageViewerInfoImplCopyWith<_$ImageViewerInfoImpl> get copyWith =>
      __$$ImageViewerInfoImplCopyWithImpl<_$ImageViewerInfoImpl>(
          this, _$identity);
}

abstract class _ImageViewerInfo implements ImageViewerInfo {
  const factory _ImageViewerInfo(
      {final double scale,
      final double lastScale,
      final int pointersCount,
      final bool isDoubleTap,
      final Offset? lastTapLocalPosition}) = _$ImageViewerInfoImpl;

  @override
  double get scale;
  @override
  double get lastScale;
  @override
  int get pointersCount;
  @override
  bool get isDoubleTap;
  @override
  Offset? get lastTapLocalPosition;

  /// Create a copy of ImageViewerInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImageViewerInfoImplCopyWith<_$ImageViewerInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
