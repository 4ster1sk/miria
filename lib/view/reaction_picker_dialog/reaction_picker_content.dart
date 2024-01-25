import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miria/model/misskey_emoji_data.dart';
import 'package:miria/providers.dart';
import 'package:miria/repository/emoji_repository.dart';
import 'package:miria/repository/general_settings_repository.dart';
import 'package:miria/view/common/account_scope.dart';
import 'package:miria/view/common/misskey_notes/custom_emoji.dart';
import 'package:miria/view/dialogs/simple_message_dialog.dart';
import 'package:miria/view/themes/app_theme.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReactionPickerContent extends ConsumerStatefulWidget {
  final FutureOr Function(MisskeyEmojiData emoji) onTap;
  final bool isAcceptSensitive;

  const ReactionPickerContent({
    super.key,
    required this.onTap,
    required this.isAcceptSensitive,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      ReactionPickerContentState();
}

class ReactionPickerContentState extends ConsumerState<ReactionPickerContent> {
  final categoryList = <String>[];
  EmojiRepository get emojiRepository =>
      ref.read(emojiRepositoryProvider(AccountScope.of(context)));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    categoryList
      ..clear()
      ..addAll(emojiRepository.emoji
              ?.map((e) => e.category)
              .toSet()
              .toList()
              .whereNotNull() ??
          []);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EmojiSearch(
            onTap: widget.onTap,
            isAcceptSensitive: widget.isAcceptSensitive,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categoryList.length,
            itemBuilder: (context, index) => ExpansionTile(
              title: Text(categoryList[index]),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        for (final emoji in (emojiRepository.emoji ?? []).where(
                            (element) =>
                                element.category == categoryList[index]))
                          EmojiButton(
                            emoji: emoji.emoji,
                            onTap: widget.onTap,
                            isAcceptSensitive: widget.isAcceptSensitive,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EmojiButton extends ConsumerStatefulWidget {
  final MisskeyEmojiData emoji;
  final FutureOr Function(MisskeyEmojiData emoji) onTap;
  final bool isForceVisible;
  final bool isAcceptSensitive;
  final bool isSelect;

  const EmojiButton({
    super.key,
    required this.emoji,
    required this.onTap,
    this.isForceVisible = false,
    required this.isAcceptSensitive,
    this.isSelect = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EmojiButtonState();
}

class EmojiButtonState extends ConsumerState<EmojiButton> {
  late var isVisibility = widget.isForceVisible;
  late var isVisibilityOnceMore = widget.isForceVisible;

  @override
  Widget build(BuildContext context) {
    final disabled = !widget.isAcceptSensitive && widget.emoji.isSensitive;
    return VisibilityDetector(
      key: Key(widget.emoji.baseName),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction != 0) {
          setState(() {
            isVisibility = true;
            isVisibilityOnceMore = true;
          });
        }
      },
      child: DecoratedBox(
        decoration: disabled && isVisibility
            ? BoxDecoration(color: Theme.of(context).disabledColor)
            : const BoxDecoration(),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll((widget.isSelect)
                ? Theme.of(context).primaryColor.withOpacity(0.5)
                : Colors.transparent),
            padding: MaterialStatePropertyAll(EdgeInsets.all(5)),
            elevation: MaterialStatePropertyAll(0),
            minimumSize: MaterialStatePropertyAll(Size.zero),
            overlayColor: MaterialStatePropertyAll(AppTheme.of(context).colorTheme.accentedBackground),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            if (!isVisibility) return;
            if (disabled) {
              SimpleMessageDialog.show(
                context,
                S.of(context).disabledUsingSensitiveCustomEmoji,
              );
            } else {
              widget.onTap.call(widget.emoji);
            }
          },
          child: isVisibility
              ? SizedBox(
                  height: MediaQuery.textScalerOf(context).scale(32),
                  child: CustomEmoji(emojiData: widget.emoji),
                )
              : SizedBox(
                  width: MediaQuery.textScalerOf(context).scale(32),
                  height: MediaQuery.textScalerOf(context).scale(32),
                ),
        ),
      ),
    );
  }
}

class EmojiSearch extends ConsumerStatefulWidget {
  final FutureOr Function(MisskeyEmojiData emoji) onTap;
  final bool isAcceptSensitive;

  const EmojiSearch({
    super.key,
    required this.onTap,
    required this.isAcceptSensitive,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => EmojiSearchState();
}

class EmojiSearchState extends ConsumerState<EmojiSearch> {
  final emojis = <MisskeyEmojiData>[];

  int index = -1;

  EmojiRepository get emojiRepository =>
      ref.read(emojiRepositoryProvider(AccountScope.of(context)));

  GeneralSettingsRepository get generalSettingsRepository =>
      ref.read(generalSettingsRepositoryProvider);

  TextEditingController textController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    emojis.clear();
    emojis.addAll(emojiRepository.defaultEmojis().toList());
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          index = -1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
            child: TextField(
          controller: textController,
          focusNode: focusNode,
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
          autofocus: ref
              .read(generalSettingsRepositoryProvider)
              .settings
              .reactionSearchAutofocus,
          keyboardType: TextInputType.emailAddress,
          onSubmitted: (value) {
            if (emojis.length > index) {
              widget.onTap(emojis[index]);
            }
          },
          onChanged: (value) {
            if (value.endsWith(" ")) {
              textController.text = value.substring(0, value.length - 1);
              setState(() {
                index++;
                if (index > emojis.length) {
                  index = 0;
                }
              });
            } else {
              index = -1;
              Future(() async {
                print(value);
                final result = await emojiRepository.searchEmojis(value);
                if (!mounted) return;
                setState(() {
                  emojis.clear();
                  emojis.addAll(result);
                });
                
              });
            }
          },
        )),
        if (Platform.isAndroid || Platform.isIOS)
          IconButton(
            onPressed: () => {
              setState(() {
                final f =
                    !generalSettingsRepository.settings.reactionSearchAutofocus;
                final settings = generalSettingsRepository.settings
                    .copyWith(reactionSearchAutofocus: f);
                generalSettingsRepository.update(settings);
                if (f) {
                  focusNode.requestFocus();
                } else {
                  primaryFocus?.unfocus();
                }
              })
            },
            icon: Icon(Icons.keyboard,
                color:
                    (generalSettingsRepository.settings.reactionSearchAutofocus)
                        ? Theme.of(context).primaryColor
                        : null),
          )
      ]),
      const Padding(padding: EdgeInsets.only(top: 10)),
      Align(
          alignment: Alignment.topLeft,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              for (int i = 0; emojis.length > i; i++)
                EmojiButton(
                  emoji: emojis[i],
                  onTap: widget.onTap,
                  isForceVisible: true,
                  isAcceptSensitive: widget.isAcceptSensitive,
                  isSelect: (index == i),
                )
            ],
          ))
    ]);
  }
}
