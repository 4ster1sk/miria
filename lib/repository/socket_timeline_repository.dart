import "dart:async";
import "dart:math";

import "package:collection/collection.dart";
import "package:flutter/foundation.dart";
import "package:miria/extensions/date_time_extension.dart";
import "package:miria/model/account.dart";
import "package:miria/providers.dart";
import "package:miria/repository/account_repository.dart";
import "package:miria/repository/emoji_repository.dart";
import "package:miria/repository/time_line_repository.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:uuid/uuid.dart";

part "socket_timeline_repository.g.dart";

@Riverpod(keepAlive: true)
Future<StreamingController> misskeyStreaming(Ref ref, Misskey misskey) async {
  return await misskey.streamingService.stream();
}

abstract class SocketTimelineRepository extends TimelineRepository {
  final Misskey misskey;
  final Account account;
  late final EmojiRepository emojiRepository = ref.read(
    emojiRepositoryProvider(account),
  );
  bool isReconnecting = false;
  late final AccountRepository accountRepository = ref.read(
    accountRepositoryProvider.notifier,
  );

  StreamingController? streamingController;
  bool isLoading = true;
  (Object?, StackTrace)? error;
  Channel get channel;
  Map<String, dynamic> get parameters;
  String? timelineId;
  String? mainId;
  List<String> subscribedIds = [];
  Ref ref;
  StreamSubscription<StreamingResponse>? timelineSubscription;
  StreamSubscription<StreamingResponse>? mainSubscription;

  /// disconnect / dispose のたびに増え、飛翔中の startTimeLine を無効化する。
  int _connectionEpoch = 0;
  Future<void>? _startInFlight;
  int? _startInFlightEpoch;

  SocketTimelineRepository(
    this.misskey,
    this.account,
    super.noteRepository,
    super.generalSettingsRepository,
    super.tabSetting,
    this.ref,
  );

  bool get _isStreamingActive =>
      subscribedIds.isNotEmpty &&
      timelineSubscription != null &&
      mainSubscription != null;

  bool _isCurrentEpoch(int epoch) => epoch == _connectionEpoch;

  Future<Iterable<Note>> requestNotes({String? untilId});
  void reloadLatestNotes() {
    moveToOlder();
    unawaited(() async {
      final resultNotes = await requestNotes();
      if (olderNotes.isEmpty) {
        olderNotes.addAll(resultNotes);
        notifyListeners();
        return;
      }

      if (olderNotes.first.createdAt < resultNotes.last.createdAt) {
        olderNotes
          ..clear()
          ..addAll(resultNotes);
        notifyListeners();
        return;
      }

      for (final note in resultNotes.toList().reversed) {
        final index = olderNotes.indexWhere((element) => element.id == note.id);
        if (index != -1) {
          olderNotes[index] = note;
          // 取得済みの古いノートは
        } else {
          olderNotes.addFirst(note);
        }
        noteRepository.registerNote(note);
      }
      notifyListeners();
    }());
  }

  @override
  Future<void> startTimeLine() async {
    final epoch = _connectionEpoch;

    // 同一世代の start が進行中なら合流し、二重に addChannel しない
    final inFlight = _startInFlight;
    if (inFlight != null && _startInFlightEpoch == epoch) {
      await inFlight;
      return;
    }

    final future = _doStartTimeLine(epoch);
    _startInFlight = future;
    _startInFlightEpoch = epoch;
    try {
      await future;
    } finally {
      if (identical(_startInFlight, future)) {
        _startInFlight = null;
        _startInFlightEpoch = null;
      }
    }
  }

  Future<void> _doStartTimeLine(int epoch) async {
    try {
      await emojiRepository.loadFromSourceIfNeed();
      if (!_isCurrentEpoch(epoch)) return;
      // api/iおよびapi/metaはawaitしない
      unawaited(accountRepository.loadFromSourceIfNeed(tabSetting.acct));
      isLoading = false;
      error = null;
      notifyListeners();
    } catch (e, s) {
      if (!_isCurrentEpoch(epoch)) return;
      error = (e, s);
      isLoading = false;
      notifyListeners();
    }

    if (!_isCurrentEpoch(epoch)) return;

    // 既に同一世代で購読済みなら再 subscribe しない（冪等）
    if (_isStreamingActive) {
      await _loadInitialNotes(epoch);
      return;
    }

    if (misskey.streamingService.isClosed) {
      streamingController = await ref.refresh(
        misskeyStreamingProvider(misskey).future,
      );
    } else {
      streamingController = await ref.read(
        misskeyStreamingProvider(misskey).future,
      );
    }
    if (!_isCurrentEpoch(epoch)) return;

    await _listenStreaming(epoch);
    if (!_isCurrentEpoch(epoch)) return;

    await _loadInitialNotes(epoch);
  }

  Future<void> _loadInitialNotes(int epoch) async {
    if (olderNotes.isEmpty) {
      try {
        final resultNotes = await requestNotes();
        if (!_isCurrentEpoch(epoch)) return;
        olderNotes.addAll(resultNotes);
        notifyListeners();
      } catch (e, s) {
        if (kDebugMode) {
          print(e);
          print(s);
        }
      }
    } else {
      reloadLatestNotes();
    }
  }

  @override
  Future<void> disconnect() async {
    // 飛翔中の startTimeLine / _listenStreaming を無効化してから購読解除する
    _connectionEpoch++;
    await _teardownChannels();
  }

  Future<void> _teardownChannels() async {
    final controller = streamingController;
    final ids = List<String>.of(subscribedIds);
    subscribedIds.clear();
    timelineId = null;
    mainId = null;

    final timelineSub = timelineSubscription;
    final mainSub = mainSubscription;
    timelineSubscription = null;
    mainSubscription = null;

    await timelineSub?.cancel();
    await mainSub?.cancel();

    if (controller != null) {
      for (final id in ids) {
        await controller.removeChannel(id);
      }
    }
  }

  @override
  Future<void> reconnect() async {
    if (isReconnecting) return;
    isReconnecting = true;
    try {
      await disconnect();
      final epoch = _connectionEpoch;

      await misskey.streamingService.reconnect();
      if (!_isCurrentEpoch(epoch)) return;

      if (misskey.streamingService.isClosed) {
        streamingController = await ref.refresh(
          misskeyStreamingProvider(misskey).future,
        );
      } else {
        streamingController = await ref.read(
          misskeyStreamingProvider(misskey).future,
        );
      }
      if (!_isCurrentEpoch(epoch)) return;

      await _listenStreaming(epoch);
      if (!_isCurrentEpoch(epoch)) return;

      reloadLatestNotes();
      error = null;
      notifyListeners();
    } catch (e, s) {
      error = (e, s);
      notifyListeners();
    } finally {
      isReconnecting = false;
      notifyListeners();
    }
  }

  @override
  Future<int> previousLoad() async {
    if (newerNotes.isEmpty && olderNotes.isEmpty) {
      return -1;
    }
    final resultNotes = await requestNotes(
      untilId: olderNotes.lastOrNull?.id ?? newerNotes.first.id,
    );
    olderNotes.addAll(resultNotes);
    notifyListeners();
    return resultNotes.length;
  }

  @override
  void dispose() {
    _connectionEpoch++;
    super.dispose();
    unawaited(_teardownChannels());
  }

  @override
  Future<void> subscribe(SubscribeItem item) async {
    if (!tabSetting.isSubscribe) return;
    await ref.read(misskeyStreamingProvider(misskey).future);
    final index = subscribedList.indexWhere(
      (element) => element.noteId == item.noteId,
    );
    final isSubscribed = subscribedList.indexWhere(
      (element) =>
          element.noteId == item.noteId ||
          element.renoteId == item.noteId ||
          element.replyId == item.noteId,
    );

    if (index == -1) {
      subscribedList.add(item);
      if (isSubscribed == -1) {
        streamingController?.subNote(item.noteId);
      }
    } else {
      subscribedList[index] = item;
    }

    final renoteId = item.renoteId;

    if (renoteId != null) {
      final isRenoteSubscribed = subscribedList.indexWhere(
        (element) =>
            element.noteId == renoteId ||
            element.renoteId == renoteId ||
            element.replyId == renoteId,
      );
      if (isRenoteSubscribed == -1) {
        streamingController?.subNote(renoteId);
      }
    }

    final replyId = item.replyId;
    if (replyId != null) {
      streamingController?.subNote(replyId);
      final isRenoteSubscribed = subscribedList.indexWhere(
        (element) =>
            element.noteId == replyId ||
            element.renoteId == replyId ||
            element.replyId == replyId,
      );
      if (isRenoteSubscribed == -1) {
        streamingController?.subNote(replyId);
      }
    }
  }

  @override
  Future<void> describe(String id) async {
    if (!tabSetting.isSubscribe) return;
    await ref.read(misskeyStreamingProvider(misskey).future);
    streamingController?.unsubNote(id);
  }

  Future<void> _listenStreaming(int epoch) async {
    // 既存購読があれば閉じてから開き直す（ID上書きによる取りこぼし防止）
    if (subscribedIds.isNotEmpty ||
        timelineSubscription != null ||
        mainSubscription != null) {
      await _teardownChannels();
    }
    if (!_isCurrentEpoch(epoch)) return;

    final generatedId = const Uuid().v4();
    final generatedId2 = const Uuid().v4();
    timelineId = generatedId;
    mainId = generatedId2;
    subscribedIds
      ..add(generatedId)
      ..add(generatedId2);

    final controller = streamingController;
    if (controller == null) {
      subscribedIds.clear();
      timelineId = null;
      mainId = null;
      return;
    }

    timelineSubscription = controller
        .addChannel(channel, parameters, generatedId)
        .listen(listenTimeline);
    mainSubscription = controller
        .mainStream(id: generatedId2)
        .listen(listenMain);

    // addChannel 直後に disconnect された場合は今開いた購読を破棄する
    if (!_isCurrentEpoch(epoch)) {
      await _teardownChannels();
    }
  }

  Future<void> listenMain(StreamingResponse response) async {
    switch (response) {
      case StreamingChannelResponse(:final body):
        switch (body) {
          case ReadAllNotificationsChannelEvent():
            await accountRepository.readAllNotification(account);
          case UnreadNotificationChannelEvent():
            await accountRepository.addUnreadNotification(account);
          case ReadAllAnnouncementsChannelEvent():
            await accountRepository.removeUnreadAnnouncement(account);
          case NewChatMessageEvent():
            await accountRepository.addUnreadChatMessages(account);
          case AnnouncementCreatedChannelEvent():
          case NoteChannelEvent():
          case StatsLogChannelEvent():
          case StatsChannelEvent():
          case UserAddedChannelEvent():
          case UserRemovedChannelEvent():
          case NotificationChannelEvent():
          case MentionChannelEvent():
          case ReplyChannelEvent():
          case RenoteChannelEvent():
          case FollowChannelEvent():
          case FollowedChannelEvent():
          case UnfollowChannelEvent():
          case MeUpdatedChannelEvent():
          case PageEventChannelEvent():
          case UrlUploadFinishedChannelEvent():
          case UnreadMentionChannelEvent():
          case ReadAllUnreadMentionsChannelEvent():
          case NotificationFlushedChannelEvent():
          case UnreadSpecifiedNoteChannelEvent():
          case ReadAllUnreadSpecifiedNotesChannelEvent():
          case ReadAllAntennasChannelEvent():
          case UnreadAntennaChannelEvent():
          case MyTokenRegeneratedChannelEvent():
          case SigninChannelEvent():
          case RegistryUpdatedChannelEvent():
          case DriveFileCreatedChannelEvent():
          case ReadAntennaChannelEvent():
          case ReceiveFollowRequestChannelEvent():
          case FallbackChannelEvent():
          case ReactedChannelEvent():
          case UnreactedChannelEvent():
          case DeletedChannelEvent():
          case PollVotedChannelEvent():
          case UpdatedChannelEvent():
            break;
          case ChatMessageChannelEvent():
          case ChatDeletedChannelEvent():
          case ChatReactChannelEvent():
          case ChatUnreactChannelEvent():
            break;
        }
      case StreamingChannelEmojiAddedResponse():
      case StreamingChannelEmojiUpdatedResponse():
      case StreamingChannelEmojiDeletedResponse():
        await emojiRepository.loadFromSource();

      case StreamingChannelAnnouncementCreatedResponse(:final body):
        await accountRepository.createUnreadAnnouncement(
          account,
          body.announcement,
        );
      case StreamingChannelNoteUpdatedResponse():
      case StreamingChannelUnknownResponse():
    }
  }

  Future<void> listenTimeline(StreamingResponse response) async {
    switch (response) {
      case StreamingChannelResponse(:final body):
        switch (body) {
          case NoteChannelEvent(:final body):
            newerNotes.add(body);
            notifyListeners();
          case ReadAllNotificationsChannelEvent():
          case UnreadNotificationChannelEvent():
          case ReadAllAnnouncementsChannelEvent():
          case AnnouncementCreatedChannelEvent():
          case StatsLogChannelEvent():
          case StatsChannelEvent():
          case UserAddedChannelEvent():
          case UserRemovedChannelEvent():
          case NotificationChannelEvent():
          case MentionChannelEvent():
          case ReplyChannelEvent():
          case RenoteChannelEvent():
          case FollowChannelEvent():
          case FollowedChannelEvent():
          case UnfollowChannelEvent():
          case MeUpdatedChannelEvent():
          case PageEventChannelEvent():
          case UrlUploadFinishedChannelEvent():
          case UnreadMentionChannelEvent():
          case ReadAllUnreadMentionsChannelEvent():
          case NotificationFlushedChannelEvent():
          case UnreadSpecifiedNoteChannelEvent():
          case ReadAllUnreadSpecifiedNotesChannelEvent():
          case ReadAllAntennasChannelEvent():
          case UnreadAntennaChannelEvent():
          case MyTokenRegeneratedChannelEvent():
          case SigninChannelEvent():
          case RegistryUpdatedChannelEvent():
          case DriveFileCreatedChannelEvent():
          case ReadAntennaChannelEvent():
          case ReceiveFollowRequestChannelEvent():
          case FallbackChannelEvent():
            break;
          case NewChatMessageEvent():
          case ChatMessageChannelEvent():
          case ChatDeletedChannelEvent():
          case ChatReactChannelEvent():
          case ChatUnreactChannelEvent():
        }
      case StreamingChannelNoteUpdatedResponse(:final body):
        switch (body) {
          case ReactedChannelEvent(:final id, :final body):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;
            final reaction = Map.of(registeredNote.reactions);
            reaction[body.reaction] = (reaction[body.reaction] ?? 0) + 1;
            final emoji = body.emoji;
            final reactionEmojis = Map.of(registeredNote.reactionEmojis);
            if (emoji != null && !body.reaction.endsWith("@.:")) {
              reactionEmojis[emoji.name] = emoji.url;
            }
            noteRepository.registerNote(
              registeredNote.copyWith(
                reactions: reaction,
                reactionEmojis: reactionEmojis,
                myReaction: body.userId == account.i.id
                    ? (emoji?.name != null ? ":${emoji?.name}:" : null)
                    : registeredNote.myReaction,
              ),
            );
          case UnreactedChannelEvent(:final body, :final id):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;
            final reaction = Map.of(registeredNote.reactions);
            reaction[body.reaction] = max(
              (reaction[body.reaction] ?? 0) - 1,
              0,
            );
            if (reaction[body.reaction] == 0) {
              reaction.remove(body.reaction);
            }
            final emoji = body.emoji;
            final reactionEmojis = Map.of(registeredNote.reactionEmojis);
            if (emoji != null && !body.reaction.endsWith("@.:")) {
              reactionEmojis[emoji.name] = emoji.url;
            }
            noteRepository.registerNote(
              registeredNote.copyWith(
                reactions: reaction,
                reactionEmojis: reactionEmojis,
                myReaction: body.userId == account.i.id
                    ? ""
                    : registeredNote.myReaction,
              ),
            );
          case PollVotedChannelEvent(:final body, :final id):
            final registeredNote = noteRepository.notes[id];
            if (registeredNote == null) return;

            final poll = registeredNote.poll;
            if (poll == null) return;

            final choices = poll.choices.toList();
            choices[body.choice] = choices[body.choice].copyWith(
              votes: choices[body.choice].votes + 1,
            );
            noteRepository.registerNote(
              registeredNote.copyWith(poll: poll.copyWith(choices: choices)),
            );
          case UpdatedChannelEvent(:final body):
            final note = noteRepository.notes[timelineId];
            if (note == null) return;
            noteRepository.registerNote(
              note.copyWith(
                text: body.text,
                cw: body.cw,
                updatedAt: DateTime.now(),
              ),
            );
          case DeletedChannelEvent():
        }
      case StreamingChannelEmojiAddedResponse():
      case StreamingChannelEmojiUpdatedResponse():
      case StreamingChannelEmojiDeletedResponse():
        await emojiRepository.loadFromSource();
      case StreamingChannelUnknownResponse():
      case StreamingChannelAnnouncementCreatedResponse():
    }
  }
}
