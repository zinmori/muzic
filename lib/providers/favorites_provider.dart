import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteSongsNotifier extends StateNotifier<List<SongModel>> {
  FavoriteSongsNotifier() : super([]) {
    loadFavoritesFromSharedPreferences();
  }

  Future<void> toggleSongFavoriteStatus(SongModel entity) async {
    final songIsFavorite = state.any((element) => element.id == entity.id);

    if (songIsFavorite) {
      await _removeSongFromFavorites(entity);
    } else {
      state = [...state, entity];
      await _saveFavoritesToSharedPreferences(state);
    }
  }

  Future<void> _saveFavoritesToSharedPreferences(
      List<SongModel> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson =
        favorites.map((song) => jsonEncode(song.getMap)).toList();
    print(favoritesJson);
    prefs.setStringList('favorites', favoritesJson);
  }

  Future<void> _removeSongFromFavorites(SongModel entity) async {
    state = state.where((e) => e.id != entity.id).toList();
    await _saveFavoritesToSharedPreferences(state);
  }

  Future<void> loadFavoritesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    final favorites = favoritesJson
        .map((json) => SongModel(jsonDecode(json) as Map<String, dynamic>))
        .toList();
    print(favorites);
    state = favorites;
  }
}

final favoriteSongsProvider =
    StateNotifierProvider<FavoriteSongsNotifier, List<SongModel>>((ref) {
  return FavoriteSongsNotifier();
});
