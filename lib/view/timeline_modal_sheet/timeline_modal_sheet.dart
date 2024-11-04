import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/avatar_icon.dart";
import "package:miria/view/common/misskey_notes/mfm_text.dart";
import "package:miria/view/timeline_modal_sheet/home_timeline.dart";
import "package:miria/view/timeline_modal_sheet/local_timeline.dart";

@RoutePage()
class TimelineModalSheet extends HookConsumerWidget {
  final Account account;

  const TimelineModalSheet({
    required this.account,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        AccountContextScope.as(
            account: account,
            child: ListTile(
              leading: AvatarIcon(user: account.i),
              title: SimpleMfmText(
                account.i.name ?? account.i.username,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                account.acct.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
        ListTile(
          leading: const Icon(Icons.home),
          title: Text(S.of(context).homeTimeline),
          onTap: () async =>
            Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountContextScope.as(
                      account: account,
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(S.of(context).homeTimeline),
                        ),
                        body: HomeTimeline(account: account),
                      ),
                    ),
                  ),
            ),
        ),
        ListTile(
          leading: const Icon(Icons.satellite_alt_outlined),
          title: Text(S.of(context).localTimeline),
          onTap: () async =>
            Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AccountContextScope.as(
                      account: account,
                      child: Scaffold(
                        appBar: AppBar(
                          title: Text(S.of(context).localTimeline),
                        ),
                        body: LocalTimeline(account: account),
                      ),
                    ),
                  ),
            ),
        ),
        ListTile(
          leading: const Icon(Icons.settings_input_antenna),
          title: Text(S.of(context).antenna),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            Navigator.of(context).pop();
            await context.pushRoute(AntennaSelectModalRoute(account: account));
          },
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: Text(S.of(context).list),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            Navigator.of(context).pop();
            await context.pushRoute(ListSelectModalRoute(account: account));
          },
        ),
        ListTile(
          leading: const Icon(Icons.tv),
          title: Text(S.of(context).channel),
          trailing: const Icon(Icons.keyboard_arrow_right),
          onTap: () async {
            Navigator.of(context).pop();
            await context.pushRoute(ChannelSelectModalRoute(account: account));
          },
        ),
      ],
    );
  }
}
