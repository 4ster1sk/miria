import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:miria/providers.dart";
import "package:miria/router/app_router.dart";
import "package:miria/view/common/misskey_notes/misskey_note.dart";
import "package:miria/view/common/pushable_listview.dart";
import "package:misskey_dart/misskey_dart.dart";
import "package:mockito/mockito.dart";

import "../../test_util/default_root_widget.dart";
import "../../test_util/mock.mocks.dart";
import "../../test_util/test_datas.dart";
import "../../test_util/widget_tester_extension.dart";

void main() {
  group("お気に入り一覧", () {
    late MockMisskey misskey;
    late MockMisskeyI i;

    // お気に入りIDはお気に入りした時刻由来、ノートIDは投稿時刻由来で値域が
    // まったく異なる。取り違えを検出できるよう、意図的に別の体系の値にする。
    Note note(String id) => TestData.note1.copyWith(id: "note$id");
    IFavoritesResponse favorite(String id) {
      final target = note(id);
      return IFavoritesResponse(
        id: "fav$id",
        createdAt: DateTime.parse("2023-06-17T16:08:52.675Z"),
        noteId: target.id,
        note: target,
      );
    }

    setUp(() {
      misskey = MockMisskey();
      i = MockMisskeyI();
      when(misskey.i).thenReturn(i);
    });

    Widget buildWidget() => ProviderScope(
      overrides: [
        misskeyProvider.overrideWith((ref, account) => misskey),
        cacheManagerProvider.overrideWith((ref) => MockCacheManager()),
      ],
      child: DefaultRootWidget(
        initialRoute: FavoritedNoteRoute(
          accountContext: TestData.accountContext,
        ),
      ),
    );

    testWidgets("お気に入りしたノートが表示されること", (tester) async {
      when(
        i.favorites(any),
      ).thenAnswer((_) async => const <IFavoritesResponse>[]);
      when(
        i.favorites(const IFavoritesRequest()),
      ).thenAnswer((_) async => [favorite("1"), favorite("2")]);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PushableListView<IFavoritesResponse>), findsOneWidget);
      expect(find.byType(MisskeyNote), findsNWidgets(2));
    });

    // untilIdのカーソルはお気に入りレコードのIDで、ノートIDを渡すと
    // 2ページ目が空になる・大きく飛ぶ・重複する
    // https://git.tomadoi.com/misskey/miria/issues/31
    testWidgets("「さらに読み込む」でお気に入りIDをuntilIdに渡すこと", (tester) async {
      // 具体的なstubが後勝ちになるよう、先に既定を置く
      when(
        i.favorites(any),
      ).thenAnswer((_) async => const <IFavoritesResponse>[]);
      when(
        i.favorites(const IFavoritesRequest()),
      ).thenAnswer((_) async => [favorite("1"), favorite("2")]);
      when(
        i.favorites(const IFavoritesRequest(untilId: "fav2")),
      ).thenAnswer((_) async => [favorite("3")]);

      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      expect(find.byType(MisskeyNote), findsNWidgets(2));

      await tester.pageNation();

      // 2ページ目のぶんが足されていること
      expect(find.byType(MisskeyNote), findsNWidgets(3));
      // ノートIDを渡していた場合はuntilIdが"note2"になり、この検証が落ちる
      verify(i.favorites(const IFavoritesRequest(untilId: "fav2"))).called(1);
    });
  });
}
