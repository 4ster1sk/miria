import "package:auto_route/auto_route.dart";
import "package:flutter/material.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/view/channels_page/channel_timeline.dart";
import "package:miria/view/common/account_scope.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";

@RoutePage()
class ChannelSelectModalSheet extends ConsumerWidget
    implements AutoRouteWrapper {
  const ChannelSelectModalSheet({
    required this.account,
    super.key,
  });

  final Account account;

  @override
  Widget wrappedRoute(BuildContext context) =>
      AccountContextScope.as(account: account, child: this);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PushableListView(
        initializeFuture: () async {
          final response = await ref
              .read(misskeyPostContextProvider)
              .channels
              .followed(const ChannelsFollowedRequest());
          return response.toList();
        },
        nextFuture: (lastItem, _) async {
          final response = await ref
              .read(misskeyPostContextProvider)
              .channels
              .followed(ChannelsFollowedRequest(untilId: lastItem.id));
          return response.toList();
        },
        itemBuilder: (context, channel) => ListTile(
              title: Text(channel.name),
              onTap: () async => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AccountContextScope.as(
                    account: account,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text(channel.name),
                      ),
                      body: ChannelTimeline(channelId: channel.id),
                    ),
                  ),
                ),
              ),
            ));
  }
}
