import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cat_tinder/src/model/cat.dart';

class CatService {
  Future<Cat> fetchRandomCat() async {
    print("Запрос к API");
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1'),
        headers: {'x-api-key': 'live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf'},
      );
      print("Ответ от API получен: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];

        print("Котик получен, изображение: ${data['url']}, порода: ${data['breeds'][0]['name']}");
        final Cat cat = Cat.fromJson(data);
        return cat;
      } else {
        throw Exception('Ошибка загрузки данных: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка при запросе к API: $e');
    }
  }
}
