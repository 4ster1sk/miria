// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_detail_page.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// クリップの情報を clips/show で取得する。
///
/// 自分のクリップ一覧（clipsProvider）にないクリップ（リモートユーザーのクリップや
/// 一覧の先頭ページに載っていない自分のクリップ）のタイトル等に使う。
/// clips/show は requireCredential: false のため、デモアカウントでも取得できる。

@ProviderFor(_clipShow)
final _clipShowProvider = _ClipShowFamily._();

/// クリップの情報を clips/show で取得する。
///
/// 自分のクリップ一覧（clipsProvider）にないクリップ（リモートユーザーのクリップや
/// 一覧の先頭ページに載っていない自分のクリップ）のタイトル等に使う。
/// clips/show は requireCredential: false のため、デモアカウントでも取得できる。

final class _ClipShowProvider
    extends $FunctionalProvider<AsyncValue<Clip>, Clip, FutureOr<Clip>>
    with $FutureModifier<Clip>, $FutureProvider<Clip> {
  /// クリップの情報を clips/show で取得する。
  ///
  /// 自分のクリップ一覧（clipsProvider）にないクリップ（リモートユーザーのクリップや
  /// 一覧の先頭ページに載っていない自分のクリップ）のタイトル等に使う。
  /// clips/show は requireCredential: false のため、デモアカウントでも取得できる。
  _ClipShowProvider._({
    required _ClipShowFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'_clipShowProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = misskeyGetContextProvider;
  static final $allTransitiveDependencies1 =
      MisskeyGetContextProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_clipShowHash();

  @override
  String toString() {
    return r'_clipShowProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Clip> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Clip> create(Ref ref) {
    final argument = this.argument as String;
    return _clipShow(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _ClipShowProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_clipShowHash() => r'517299596c32748aee322271fd1ca209c0c87f70';

/// クリップの情報を clips/show で取得する。
///
/// 自分のクリップ一覧（clipsProvider）にないクリップ（リモートユーザーのクリップや
/// 一覧の先頭ページに載っていない自分のクリップ）のタイトル等に使う。
/// clips/show は requireCredential: false のため、デモアカウントでも取得できる。

final class _ClipShowFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Clip>, String> {
  _ClipShowFamily._()
    : super(
        retry: null,
        name: r'_clipShowProvider',
        dependencies: <ProviderOrFamily>[misskeyGetContextProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _ClipShowProvider.$allTransitiveDependencies0,
          _ClipShowProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  /// クリップの情報を clips/show で取得する。
  ///
  /// 自分のクリップ一覧（clipsProvider）にないクリップ（リモートユーザーのクリップや
  /// 一覧の先頭ページに載っていない自分のクリップ）のタイトル等に使う。
  /// clips/show は requireCredential: false のため、デモアカウントでも取得できる。

  _ClipShowProvider call(String clipId) =>
      _ClipShowProvider._(argument: clipId, from: this);

  @override
  String toString() => r'_clipShowProvider';
}
