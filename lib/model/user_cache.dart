import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:miria/model/acct.dart';
import 'package:misskey_dart/misskey_dart.dart';

part 'user_cache.freezed.dart';
part 'user_cache.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class UserCache with _$UserCache {
  const UserCache._();

  const factory UserCache({
    required String userId,
    required String host,
    required Map<String, UserLite> users,
  }) = _UserCache;

  factory UserCache.fromJson(Map<String, dynamic> json) =>
      _$UserCacheFromJson(json);

  Acct get acct {
    return Acct(
      host: host,
      username: userId,
    );
  }
}
