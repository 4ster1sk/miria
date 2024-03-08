import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/model/user_cache.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class UserCacheRepository extends ChangeNotifier {
  final List<UserCache> _userCache = [];
  List<UserCache> get userCache => _userCache;

  Future<void> load() async {
    final f = File(await getSettingPath());
    if (kDebugMode) print("path: ${f.path}");
    try {
      json.decode(utf8.decode(gzip.decode(await f.readAsBytes()))).forEach((e) {
        _userCache.add(UserCache.fromJson(e));
      });
    } catch (e) {
      if (kDebugMode) print(e);
      _userCache.clear();
    }
  }

  Future<void> insert(
      Iterable<UserDetailed> userDetails, Account account) async {
    var c =
        _userCache.where((element) => element.acct == account.acct).firstOrNull;
    if (c == null) {
      c = UserCache(userId: account.userId, host: account.host, users: {});
      _userCache.add(c);
    }
    for (final d in userDetails) {
      c.users[d.acct] = UserLite.fromJson(d.toJson());
    }
    await save();
  }

  Future<void> save() async {
    notifyListeners();

    await File(await getSettingPath())
        .writeAsBytes(gzip.encode(utf8.encode(jsonEncode(_userCache))));
  }

  Future<String> getSettingPath() async {
    return join(
        (await getApplicationSupportDirectory()).path, "userDetails.json.gz");
  }
}
