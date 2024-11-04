import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/model/users_list_settings.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/state_notifier/user_list_page/users_lists_notifier.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/error_detail.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ListSelectModalSheet extends ConsumerWidget implements AutoRouteWrapper {
  const ListSelectModalSheet({
    required this.account,
    super.key,
  });

  final Account account;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lists = ref.watch(usersListsNotifierProvider);

    return lists.when(
      data: (lists) {
        return ListView.builder(
          itemCount: lists.length + 1,
          itemBuilder: (context, index) {
            if (index < lists.length) {
              final list = lists[index];
              return ListTile(
                title: Text(list.name ?? ""),
                onTap: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await context.pushRoute(
                    UsersListTimelineRoute(
                      accountContext: ref.read(accountContextProvider),
                      list: list,
                    ),
                  );
                },
              );
            }
          },
        );
      },
      error: (e, st) => Center(child: ErrorDetail(error: e, stackTrace: st)),
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
