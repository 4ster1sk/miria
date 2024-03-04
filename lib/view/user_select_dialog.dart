import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/extensions/origin_extension.dart';
import 'package:miria/extensions/user_extension.dart';
import 'package:miria/model/account.dart';
import 'package:miria/providers.dart';
import 'package:miria/router/app_router.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/pushable_listview.dart';
import 'package:miria/view/user_page/user_list_item.dart';
import 'package:misskey_dart/misskey_dart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSelectDialog extends StatelessWidget {
  final Account account;

  const UserSelectDialog({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return AccountScope(
      account: account,
      child: AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          child: UserSelectContent(
            onSelected: (item) => Navigator.of(context).pop(item),
          ),
        ),
      ),
    );
  }
}

class UserSelectContent extends ConsumerStatefulWidget {
  final void Function(User) onSelected;
  final FocusNode? focusNode;
  final bool isDetail;

  const UserSelectContent({
    super.key,
    required this.onSelected,
    this.focusNode,
    this.isDetail = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      UserSelectContentState();
}

final usersSelectDialogQueryProvider = StateProvider.autoDispose((ref) => "");
final usersSelectDialogOriginProvider =
    StateProvider.autoDispose((ref) => Origin.combined);

class _AutocompleteOption extends Object {
  UserLite? user;
  String text;

  _AutocompleteOption(this.text, this.user);
}

class UserSelectContentState extends ConsumerState<UserSelectContent> {
  final queryController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }

  Widget buildInputField() {
    return LayoutBuilder(
        builder: (context, constraints) => RawAutocomplete<_AutocompleteOption>(
              textEditingController: queryController,
              focusNode:
                  (widget.focusNode != null) ? widget.focusNode : focusNode,
              displayStringForOption: (m) => m.text,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<_AutocompleteOption>.empty();
                }
                return [
                  _AutocompleteOption(textEditingValue.text, null),
                  ...ref
                          .read(userCacheRepositoryProvider)
                          .userCache
                          .where((element) =>
                              element.acct == AccountScope.of(context).acct)
                          .firstOrNull
                          ?.users
                          .entries
                          .where((e) {
                            final v = textEditingValue.text.toLowerCase();
                            return e.value.acct.toLowerCase().contains(v) ||
                                (e.value.name?.toLowerCase().contains(v) ??
                                    false);
                          })
                          .map(
                              (e) => _AutocompleteOption(e.value.acct, e.value))
                          .toList() ??
                      []
                ];
              },
              onSelected: (_AutocompleteOption value) {
                if (value.user != null) {
                  widget.onSelected(value.user!);
                } else {
                  ref.read(usersSelectDialogQueryProvider.notifier).state =
                      value.text;
                }
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  autofocus: true,
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
              optionsViewBuilder: (
                _,
                onSelected,
                options,
              ) {
                return AccountScope(
                  account: AccountScope.of(context),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        child: SizedBox(
                          width: constraints.biggest.width,
                          height: 46 + (79 * 3),
                          child: ListView.builder(
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final _AutocompleteOption option =
                                  options.elementAt(index);
                              final bool highlight =
                                  AutocompleteHighlightedOption.of(context) ==
                                      index;
                              return ListTile(
                                tileColor: highlight
                                    ? Theme.of(context).focusColor
                                    : null,
                                contentPadding: (index == 0)
                                    ? null
                                    : const EdgeInsets.all(0),
                                title: (index == 0)
                                    ? Text(
                                        S.of(context).searchUser(option.text))
                                    : UserListItem(
                                        user: option.user!,
                                        onTap: () => onSelected(option)),
                                onTap: () => onSelected(option),
                              );
                            },
                          ),
                        ),
                      )),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    final origin = ref.watch(usersSelectDialogOriginProvider);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildInputField(),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        LayoutBuilder(
          builder: (context, constraints) {
            return ToggleButtons(
              isSelected: [
                for (final element in Origin.values) element == origin
              ],
              constraints: BoxConstraints.expand(
                  width: constraints.maxWidth / Origin.values.length -
                      Theme.of(context)
                              .toggleButtonsTheme
                              .borderWidth!
                              .toInt() *
                          Origin.values.length),
              onPressed: (index) {
                ref.read(usersSelectDialogOriginProvider.notifier).state =
                    Origin.values[index];
              },
              children: [
                for (final element in Origin.values)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(element.displayName(context)),
                  ),
              ],
            );
          },
        ),
        Expanded(
          child: UsersSelectContentList(
            onSelected: widget.onSelected,
            isDetail: widget.isDetail,
          ),
        )
      ],
    );
  }
}

class UsersSelectContentList extends ConsumerWidget {
  const UsersSelectContentList({
    super.key,
    required this.onSelected,
    required this.isDetail,
  });
  final void Function(User) onSelected;
  final bool isDetail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(usersSelectDialogQueryProvider);
    final origin = ref.watch(usersSelectDialogOriginProvider);

    return PushableListView(
      listKey: ObjectKey(Object.hashAll([
        query,
        origin,
      ])),
      initializeFuture: () async {
        if (query.isEmpty) {
          final response = await ref
              .read(misskeyProvider(AccountScope.of(context)))
              .users
              .getFrequentlyRepliedUsers(UsersGetFrequentlyRepliedUsersRequest(
                  userId: AccountScope.of(context).i.id));
          return response.map((e) => e.user).toList();
        }

        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .search(UsersSearchRequest(query: query, origin: origin));
        return response.toList();
      },
      nextFuture: (lastItem, length) async {
        if (query.isEmpty) {
          return [];
        }
        final response = await ref
            .read(misskeyProvider(AccountScope.of(context)))
            .users
            .search(UsersSearchRequest(
              query: query,
              origin: origin,
              offset: length,
            ));
        return response.toList();
      },
      itemBuilder: (context2, item) => UserListItem(
        user: item,
        isDetail: isDetail,
        onTap: () => onSelected.call(item),
      ),
    );
  }
}
