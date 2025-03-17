import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/service/cat_service.dart';
import 'package:cat_tinder/src/view/cat_view.dart';

class CatPresenter {
  final CatView view;
  final CatService service = CatService();

  CatPresenter(this.view);

  Future<void> loadRandomCat() async {
    try {
      print("Загружаем кота...");
      final cat = await service.fetchRandomCat();
      print("Кот загружен: ${cat.breed}");
      view.updateCat(cat);
    } catch (e) {
      print("Ошибка загрузки кота: $e");
    }
  }
}
