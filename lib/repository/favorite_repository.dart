import "package:flutter/foundation.dart";
import "package:miria/repository/note_repository.dart";
import "package:misskey_dart/misskey_dart.dart";

class FavoriteRepository extends ChangeNotifier {
  final Misskey misskey;
  final NoteRepository noteRepository;

  FavoriteRepository(this.misskey, this.noteRepository);

  List<IFavoritesResponse> _favorites = [];
  List<Note> get notes => _favorites.map((e) => e.note).toList();

  Future<void> getFavorites() async {
    final response = await misskey.i.favorites(
      IFavoritesRequest(
        untilId: _favorites.isEmpty ? null : _favorites.last.id,
        limit: 50,
      ),
    );
    _favorites = [..._favorites, ...response];
    noteRepository.registerAll(response.map((e) => e.note));

    notifyListeners();
  }
}
