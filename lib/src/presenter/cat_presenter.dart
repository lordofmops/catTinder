import 'package:cat_tinder/src/service/cat_service.dart';
import 'package:cat_tinder/src/service/local_storage.dart';
import 'package:cat_tinder/src/view/cat_view.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';

class CatPresenter {
  final CatView view;
  late CatService service = CatService();
  LocalStorage localStorage = LocalStorage();
  Connectivity connectivity = Connectivity();

  CatPresenter(this.view) {
    _init();
    _loadLikes();
  }

  Future<void> _loadLikes() async {
    final likedCats = await localStorage.getLikedCats();
    view.updateLikes(likedCats.length);
  }

  Future<void> _init() async {
    await localStorage.init();
    _loadLikes();
  }

  void handleLike(Cat cat) async {
    await localStorage.saveCat(cat.copyWith(isLiked: true), liked: true);

    final likedCats = await localStorage.getLikedCats();
    await localStorage.saveLikes(likedCats.length);

    view.updateLikes(likedCats.length);
    loadRandomCat();
  }

  Future<void> loadRandomCat() async {
    try {
      debugPrint("[info] [CatPresenter/loadRandomCat] Loading cat");

      final connectivityResult = await connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        view.showNetworkStatus(false);
        final savedCats = await localStorage.getSavedCats();
        if (savedCats.isNotEmpty) {
          view.updateCat(savedCats.first);
          return;
        }
        throw Exception('No internet connection and no saved cats');
      }

      view.showNetworkStatus(true);
      final cat = await service.fetchRandomCat();
      await localStorage.saveCat(cat);
      view.updateCat(cat);
    } catch (e) {
      debugPrint("[error] [CatPresenter/loadRandomCat] Loading cat error: $e");
      view.showError('Failed to load cat. ${e.toString()}');
    }
  }

  Future<void> updateLikes(int likes) async {
    await localStorage.saveLikes(likes);
  }
}
