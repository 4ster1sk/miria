import "package:flutter/widgets.dart";
import "package:miria/l10n/app_localizations.dart";
import "package:miria/view/user_page/user_info_notifier.dart";

enum UserPageTab {
  info,
  infoLocal,
  infoRemote,
  notes,
  notesLocal,
  notesRemote,
  clip,
  reactions,
  pages,
  plays,
}

List<UserPageTab> buildUserPageTabs(
  UserInfo? userInfo, {
  required String postAccountUserId,
}) {
  final isReactionAvailable =
      userInfo?.response.publicReactions == true ||
      (userInfo?.response.host == null &&
          userInfo?.response.username == postAccountUserId);
  final isRemoteUser =
      userInfo?.response.host != null && userInfo?.remoteResponse != null;

  if (!isRemoteUser) {
    return [
      UserPageTab.info,
      UserPageTab.notes,
      UserPageTab.clip,
      if (isReactionAvailable) UserPageTab.reactions,
      UserPageTab.pages,
      UserPageTab.plays,
    ];
  } else {
    return [
      UserPageTab.infoLocal,
      UserPageTab.infoRemote,
      UserPageTab.notesLocal,
      UserPageTab.notesRemote,
      UserPageTab.clip,
      if (isReactionAvailable) UserPageTab.reactions,
      UserPageTab.pages,
      UserPageTab.plays,
    ];
  }
}

extension UserPageTabExtension on UserPageTab {
  String label(BuildContext context) {
    switch (this) {
      case UserPageTab.info:
        return S.of(context).userInfomation;
      case UserPageTab.infoLocal:
        return S.of(context).userInfomationLocal;
      case UserPageTab.infoRemote:
        return S.of(context).userInfomationRemote;
      case UserPageTab.notes:
        return S.of(context).userNotes;
      case UserPageTab.notesLocal:
        return S.of(context).userNotesLocal;
      case UserPageTab.notesRemote:
        return S.of(context).userNotesRemote;
      case UserPageTab.clip:
        return S.of(context).clip;
      case UserPageTab.reactions:
        return S.of(context).userReactions;
      case UserPageTab.pages:
        return S.of(context).userPages;
      case UserPageTab.plays:
        return S.of(context).userPlays;
    }
  }
}

/// 旧論理タブを新タブリストへマップする。
/// 直接含まれていればそれを返し、generic<->specific 間のフォールバックを行う。
UserPageTab mapOldLogicalToNew(UserPageTab old, List<UserPageTab> newTabs) {
  if (newTabs.contains(old)) return old;
  // generic -> specific (local側へ)
  if (old == UserPageTab.info && newTabs.contains(UserPageTab.infoLocal)) {
    return UserPageTab.infoLocal;
  }
  if (old == UserPageTab.notes && newTabs.contains(UserPageTab.notesLocal)) {
    return UserPageTab.notesLocal;
  }
  // specific -> generic
  if (old == UserPageTab.infoLocal && newTabs.contains(UserPageTab.info)) {
    return UserPageTab.info;
  }
  if (old == UserPageTab.infoRemote && newTabs.contains(UserPageTab.info)) {
    return UserPageTab.info;
  }
  if (old == UserPageTab.notesLocal && newTabs.contains(UserPageTab.notes)) {
    return UserPageTab.notes;
  }
  if (old == UserPageTab.notesRemote && newTabs.contains(UserPageTab.notes)) {
    return UserPageTab.notes;
  }
  // clip / pages / plays / reactions はそのまま保持されるはずだが、
  // 万一見つからなければ先頭にフォールバック
  return newTabs.isNotEmpty ? newTabs.first : old;
}

bool userPageTabsEqual(List<UserPageTab> a, List<UserPageTab> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
