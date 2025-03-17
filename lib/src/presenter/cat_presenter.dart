import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/service/cat_service.dart';
import 'package:cat_tinder/src/view/cat_view.dart';
import 'package:flutter/foundation.dart';

class CatPresenter {
  final CatView view;
  final CatService service = CatService();

  CatPresenter(this.view);

  Future<void> loadRandomCat() async {
    try {
      debugPrint("[info] [CatPresenter/loadRandomCat] Loading cat");
      final cat = await service.fetchRandomCat();
      debugPrint("[info] [CatPresenter/loadRandomCat] Cat loaded");
      view.updateCat(cat);
    } catch (e) {
      debugPrint("[error] [CatPresenter/loadRandomCat] Loading cat error: $e");
    }
  }
}
