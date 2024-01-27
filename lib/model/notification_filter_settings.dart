import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_filter_settings.freezed.dart';

@freezed
class NotificationFilterSettings with _$NotificationFilterSettings {
  const factory NotificationFilterSettings({
    @Default(true) bool withReaction,
    @Default(true) bool withFollow,
    @Default(true) bool withUserNote,
    @Default(true) bool withRenote,
    @Default(true) bool withOther,
  }) = _NotificationFilterSettings;
  const NotificationFilterSettings._();
}
