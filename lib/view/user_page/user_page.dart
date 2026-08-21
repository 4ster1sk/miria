import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/user_page/user_clips.dart";
import "package:miria/view/user_page/user_detail.dart";
import "package:miria/view/user_page/user_info_notifier.dart";
import "package:miria/view/user_page/user_misskey_page.dart";
import "package:miria/view/user_page/user_notes.dart";
import "package:miria/view/user_page/user_page_tab.dart";
import "package:miria/view/user_page/user_plays.dart";
import "package:miria/view/user_page/user_reactions.dart";

@RoutePage()
class UserPage extends ConsumerStatefulWidget implements AutoRouteWrapper {
  final String userId;
  final AccountContext accountContext;
  const UserPage({
    required this.userId,
    required this.accountContext,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope(context: accountContext, child: this);

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<UserPageTab> _tabs = [];
  List<UserPageTab>? _pendingTabs;

  @override
  void initState() {
    super.initState();
    // 初期は情報なしとしてローカル想定で生成。長さは後で build 時に補正される。
    _tabs = buildUserPageTabs(
      null,
      postAccountUserId: widget.accountContext.postAccount.userId,
    );
    _createController(initialIndex: 0);
  }

  void _createController({required int initialIndex, double? initialValue}) {
    // 既存のリスナーを外してから dispose
    if (_tabController != null) {
      _tabController!.removeListener(_handleControllerTick);
      _tabController!.animation?.removeListener(_handleAnimationTick);
      _tabController!.dispose();
    }
    _tabController = TabController(
      vsync: this,
      length: _tabs.length,
      initialIndex: initialIndex.clamp(0, _tabs.length - 1),
    );
    // offset を保持したい場合は offset セッターで上書き（animation.value は取得専用）
    if (initialValue != null) {
      final clamped = initialValue.clamp(0, _tabs.length - 1).toDouble();
      final offset = clamped - initialIndex;
      if (offset.abs() > 0.001) {
        // offset は -1.0〜1.0 の範囲でのみ設定可能
        if (offset.abs() <= 1.0 && !_tabController!.indexIsChanging) {
          _tabController!.offset = offset.clamp(-1.0, 1.0);
        }
      }
    }
    _tabController!.addListener(_handleControllerTick);
    _tabController!.animation?.addListener(_handleAnimationTick);
  }

  bool get _isDragging {
    final c = _tabController;
    if (c == null) return false;
    if (c.indexIsChanging) return true;
    final animationValue = c.animation?.value ?? c.index.toDouble();
    final offset = animationValue - c.index.toDouble();
    // offset !=0: TabBarView ドラッグ中（指でスワイプ中は小数になる）
    return offset.abs() > 0.01;
  }

  void _handleControllerTick() {
    _tryApplyPending();
  }

  void _handleAnimationTick() {
    _tryApplyPending();
  }

  void _tryApplyPending() {
    if (_pendingTabs == null) return;
    if (_isDragging) return;
    // ドラッグが終わったら保留を適用
    final newTabs = _pendingTabs!;
    _pendingTabs = null;
    // 適用は次のフレームで setState を伴う必要がある。
    // 既に build 中でなければ setState で再ビルド。
    if (mounted) {
      setState(() {
        _applyTabsChange(newTabs);
      });
    } else {
      _applyTabsChange(newTabs);
    }
  }

  void _applyTabsChange(List<UserPageTab> newTabs) {
    if (userPageTabsEqual(_tabs, newTabs)) {
      _tabs = newTabs;
      return;
    }
    final oldTabs = _tabs;
    final oldController = _tabController;
    if (oldController == null) {
      _tabs = newTabs;
      _createController(initialIndex: 0);
      return;
    }

    final oldIndex = oldController.index.clamp(0, oldTabs.length - 1);
    final oldValue = oldController.animation?.value ?? oldIndex.toDouble();
    final offset = oldValue - oldIndex.toDouble();

    final oldLogical = oldTabs[oldIndex];
    final targetLogical = mapOldLogicalToNew(oldLogical, newTabs);
    int newIndex = newTabs.indexOf(targetLogical);
    if (newIndex == -1) newIndex = 0;

    // ドラッグ中でない場合は offset は 0 のはずだが、念のため保持。
    // ただし遅延適用のため offset はほぼ 0 になる。
    final newValue = (newIndex + offset)
        .clamp(0, newTabs.length - 1)
        .toDouble();

    _tabs = newTabs;
    _createController(initialIndex: newIndex, initialValue: newValue);
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.removeListener(_handleControllerTick);
      _tabController!.animation?.removeListener(_handleAnimationTick);
      _tabController!.dispose();
    }
    super.dispose();
  }

  Widget _buildTabContent(UserPageTab tab, UserInfo? userInfo) {
    final isRemoteUser =
        userInfo?.response.host != null && userInfo?.remoteResponse != null;
    final remoteHost = userInfo?.response.host;
    final meta = userInfo?.metaResponse;
    final remoteResponse = userInfo?.remoteResponse;

    switch (tab) {
      case UserPageTab.info:
        return UserDetailTab(userId: widget.userId);
      case UserPageTab.infoLocal:
        return UserDetailTab(userId: widget.userId);
      case UserPageTab.infoRemote:
        if (remoteResponse == null || remoteHost == null || meta == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return AccountContextScope(
          context: AccountContext(
            getAccount: Account.demoAccount(remoteHost, meta),
            postAccount: ref.read(accountContextProvider).postAccount,
          ),
          child: UserDetail(response: remoteResponse),
        );
      case UserPageTab.notes:
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: UserNotes(userId: widget.userId),
        );
      case UserPageTab.notesLocal:
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: UserNotes(userId: widget.userId),
        );
      case UserPageTab.notesRemote:
        if (remoteResponse == null || remoteHost == null || meta == null) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return AccountContextScope(
          context: AccountContext(
            getAccount: Account.demoAccount(remoteHost, meta),
            postAccount: ref.read(accountContextProvider).postAccount,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: UserNotes(
              userId: widget.userId,
              remoteUserId: remoteResponse.id,
            ),
          ),
        );
      case UserPageTab.clip:
        if (isRemoteUser &&
            remoteResponse != null &&
            remoteHost != null &&
            meta != null) {
          return AccountContextScope(
            context: AccountContext(
              getAccount: Account.demoAccount(remoteHost, meta),
              postAccount: ref.read(accountContextProvider).postAccount,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: UserClips(userId: remoteResponse.id),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: UserClips(userId: widget.userId),
          );
        }
      case UserPageTab.reactions:
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: UserReactions(userId: widget.userId),
        );
      case UserPageTab.pages:
        if (isRemoteUser &&
            remoteResponse != null &&
            remoteHost != null &&
            meta != null) {
          return AccountContextScope(
            context: AccountContext(
              getAccount: Account.demoAccount(remoteHost, meta),
              postAccount: ref.read(accountContextProvider).postAccount,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: UserMisskeyPage(userId: remoteResponse.id),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: UserMisskeyPage(userId: widget.userId),
          );
        }
      case UserPageTab.plays:
        if (isRemoteUser &&
            remoteResponse != null &&
            remoteHost != null &&
            meta != null) {
          return AccountContextScope(
            context: AccountContext(
              getAccount: Account.demoAccount(remoteHost, meta),
              postAccount: ref.read(accountContextProvider).postAccount,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: UserPlays(userId: remoteResponse.id),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: UserPlays(userId: widget.userId),
          );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInfoAsync = ref.watch(userInfoProxyProvider(widget.userId));
    final userInfo = userInfoAsync.value;

    final newTabs = buildUserPageTabs(
      userInfo,
      postAccountUserId: widget.accountContext.postAccount.userId,
    );

    // タブ構成が変化した場合の処理
    if (!userPageTabsEqual(_tabs, newTabs)) {
      if (_isDragging) {
        // フリック中は保留し、現行の _tabs / controller を維持
        _pendingTabs = newTabs;
      } else {
        // 即時適用。build 中に controller を作り替えるが、setState 不要。
        _applyTabsChange(newTabs);
      }
    } else {
      // 構成が戻った場合でも保留があれば、ドラッグ終了を待って適用
      // newTabs == _tabs なら保留はクリア
      if (_pendingTabs != null && userPageTabsEqual(_pendingTabs!, newTabs)) {
        _pendingTabs = null;
      }
    }

    // _pendingTabs がありドラッグ中でなければ次のフレームで適用されるが、
    // build 直後に dragging が終わっているケースではここで即時 flush する
    if (_pendingTabs != null && !_isDragging) {
      // この分岐は _handleAnimationTick でも処理されるが、念のため同期的にも試みる
      // setState を呼ぶと build 中に再入するため、postFrame で処理
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryApplyPending();
      });
    }

    // まだ controller が未生成なら生成
    if (_tabController == null || _tabController!.length != _tabs.length) {
      // 通常は _applyTabsChange で同期しているが、初期や不整合時の保険
      final safeIndex = (_tabController?.index ?? 0).clamp(0, _tabs.length - 1);
      _tabs = newTabs;
      _createController(initialIndex: safeIndex);
    }

    return Scaffold(
      appBar: AppBar(
        title: SimpleMfmText(
          userInfo?.response.name ?? userInfo?.response.username ?? "",
          emojis: userInfo?.response.emojis ?? {},
        ),
        actions: const [],
        bottom: TabBar(
          controller: _tabController,
          tabs: [for (final tab in _tabs) Tab(text: tab.label(context))],
          isScrollable: true,
          tabAlignment: TabAlignment.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final tab in _tabs) _buildTabContent(tab, userInfo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserDetailTab extends ConsumerWidget {
  final String userId;

  const UserDetailTab({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userDetail = ref.watch(userInfoProxyProvider(userId));

    return switch (userDetail) {
      AsyncLoading() => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      AsyncError(:final error, :final stackTrace) => ErrorDetail(
        error: error,
        stackTrace: stackTrace,
      ),
      AsyncData(:final value) => UserDetail(response: value.response),
    };
  }
}
