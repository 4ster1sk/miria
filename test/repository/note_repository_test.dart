import "package:flutter_test/flutter_test.dart";
import "package:miria/repository/note_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

import "../test_util/mock.mocks.dart";
import "../test_util/test_datas.dart";

void main() {
  group("NoteRepository ミュート判定", () {
    // TestData.note1 は TestData.account 自身のノート
    final myNote = TestData.note1.copyWith(text: "ミュート対象のノート");
    final othersNote = myNote.copyWith(
      id: "othersNoteId",
      userId: "othersUserId",
      user: myNote.user.copyWith(id: "othersUserId"),
    );

    const muteWord = MuteWord(content: ["ミュート対象"]);
    const muteRegExp = MuteWord(regExp: "/ミュート.+ノート/");

    NoteRepository createRepository({
      List<MuteWord> softMuteWords = const [],
      List<MuteWord> hardMuteWords = const [],
    }) {
      return NoteRepository(MockMisskey(), TestData.account)
        ..updateMute(softMuteWords, hardMuteWords);
    }

    group("ハードミュート", () {
      for (final (name, word) in [
        ("ワードミュート", muteWord),
        ("正規表現ミュート", muteRegExp),
      ]) {
        test("$nameは自分のノートに適用されないこと", () {
          final repository = createRepository(hardMuteWords: [word])
            ..registerNote(myNote);
          expect(repository.notes[myNote.id], isNotNull);
        });

        test("$nameは他人のノートに適用されること", () {
          final repository = createRepository(hardMuteWords: [word])
            ..registerNote(othersNote);
          expect(repository.notes[othersNote.id], isNull);
        });
      }
    });

    group("ソフトミュート", () {
      for (final (name, word) in [
        ("ワードミュート", muteWord),
        ("正規表現ミュート", muteRegExp),
      ]) {
        test("$nameは自分のノートに適用されないこと", () {
          final repository = createRepository(softMuteWords: [word])
            ..registerNote(myNote);
          expect(
            repository.noteStatuses[myNote.id]?.isIncludeMuteWord,
            isFalse,
          );
        });

        test("$nameは他人のノートに適用されること", () {
          final repository = createRepository(softMuteWords: [word])
            ..registerNote(othersNote);
          expect(
            repository.noteStatuses[othersNote.id]?.isIncludeMuteWord,
            isTrue,
          );
        });
      }
    });
  });
}
