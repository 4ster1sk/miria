import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:miria/model/notification_filter_settings.dart';

final _formKeyProvider = Provider.autoDispose((ref) => GlobalKey<FormState>());

final _initialSettingsProvider =
    Provider.autoDispose<NotificationFilterSettings>(
  (ref) => throw UnimplementedError(),
);
final _notificationFilterSettingsNotifierProvider =
    NotifierProvider.autoDispose<_NotificationFilterSettingsNotifier,
        NotificationFilterSettings>(
  _NotificationFilterSettingsNotifier.new,
  dependencies: [_initialSettingsProvider],
);

class _NotificationFilterSettingsNotifier
    extends AutoDisposeNotifier<NotificationFilterSettings> {
  @override
  NotificationFilterSettings build() {
    return ref.watch(_initialSettingsProvider);
  }

  void updateWithReaction(bool? withReaction) {
    if (withReaction != null) {
      state = state.copyWith(withReaction: withReaction);
    }
  }

  void updateWithFollow(bool? withFollow) {
    if (withFollow != null) {
      state = state.copyWith(withFollow: withFollow);
    }
  }

  void updateWithUserNote(bool? withUserNote) {
    if (withUserNote != null) {
      state = state.copyWith(withUserNote: withUserNote);
    }
  }

  void updateWithRenote(bool? withRenote) {
    if (withRenote != null) {
      state = state.copyWith(withRenote: withRenote);
    }
  }

  void updateWithOther(bool? withOther) {
    if (withOther != null) {
      state = state.copyWith(withOther: withOther);
    }
  }

  void unmarkAll() {
    _setAllFlags(false);
  }

  void markAll() {
    _setAllFlags(true);
  }

  void _setAllFlags(bool f) {
    state = state.copyWith(
        withFollow: f,
        withReaction: f,
        withRenote: f,
        withOther: f,
        withUserNote: f);
  }
}

class NotificationFilterDialog extends StatelessWidget {
  const NotificationFilterDialog(
      {super.key, this.initialSettings = const NotificationFilterSettings()});

  final NotificationFilterSettings initialSettings;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).showNotification),
      scrollable: true,
      content: ProviderScope(
        overrides: [
          _initialSettingsProvider.overrideWithValue(initialSettings),
        ],
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: const NotificationFilterSettingsForm(),
        ),
      ),
    );
  }
}

class NotificationFilterSettingsForm extends ConsumerWidget {
  const NotificationFilterSettingsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = ref.watch(_formKeyProvider);
    //final initialSettings = ref.watch(_initialSettingsProvider);
    final settings = ref.watch(_notificationFilterSettingsNotifierProvider);
    return Form(
        key: formKey,
        child: Column(children: [
          CheckboxListTile(
            title: Text(S.of(context).withReaction),
            value: settings.withReaction,
            onChanged: ref
                .read(_notificationFilterSettingsNotifierProvider.notifier)
                .updateWithReaction,
          ),
          CheckboxListTile(
            title: Text(S.of(context).withFollow),
            value: settings.withFollow,
            onChanged: ref
                .read(_notificationFilterSettingsNotifierProvider.notifier)
                .updateWithFollow,
          ),
          CheckboxListTile(
            title: Text(S.of(context).withRenote),
            value: settings.withRenote,
            onChanged: ref
                .read(_notificationFilterSettingsNotifierProvider.notifier)
                .updateWithRenote,
          ),
          CheckboxListTile(
            title: Text(S.of(context).withUserNote),
            value: settings.withUserNote,
            onChanged: ref
                .read(_notificationFilterSettingsNotifierProvider.notifier)
                .updateWithUserNote,
          ),
          CheckboxListTile(
            title: Text(S.of(context).withOther),
            value: settings.withOther,
            onChanged: ref
                .read(_notificationFilterSettingsNotifierProvider.notifier)
                .updateWithOther,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(
              onPressed: ref
                  .read(_notificationFilterSettingsNotifierProvider.notifier)
                  .unmarkAll,
              child: Text(S.of(context).unmarkAll),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(settings);
              },
              child: Text(S.of(context).done),
            )
          ]),
        ]));
  }
}
