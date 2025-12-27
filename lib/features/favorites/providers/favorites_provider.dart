import 'package:flutter/foundation.dart';
import '../data/favorites_repo.dart';
import '../data/favorite_item.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepo _repo = FavoritesRepo();
  String? _userId;

  void setUser(String? userId) {
    _userId = userId;
    notifyListeners();
  }

  bool get ready => _userId != null;

  Stream<List<FavoriteItem>> watchAll() {
    if (_userId == null) return const Stream.empty();
    return _repo.watchFavorites(_userId!);
  }

  Stream<bool> watchIsFavorite(int productId) {
    if (_userId == null) return Stream.value(false);
    return _repo.watchIsFavorite(_userId!, productId);
  }

  Future<void> toggle(FavoriteItem item) async {
    if (_userId == null) return;
    await _repo.toggle(_userId!, item);
  }

  Future<void> remove(int productId) async {
    if (_userId == null) return;
    await _repo.remove(_userId!, productId);
  }
}
