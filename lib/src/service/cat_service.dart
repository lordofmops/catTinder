import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cat_tinder/src/model/cat.dart';

class CatService {
  Future<Cat> fetchRandomCat() async {
    debugPrint("[info] [CatService/fetchRandomCat] Fetching cat");
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1'),
        headers: {'x-api-key': 'live_o8038oqDil8T8qkhapTShngvUDx2B8gjkmIIAXFC0m7Js2rsqL6y8GddBEH6vQOf'},
      );
      debugPrint("[info] [CatService/fetchRandomCat] API response code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)[0];

        debugPrint("[info] [CatService/fetchRandomCat] Cat received, breed: ${data['breeds'][0]['name']}");
        final Cat cat = Cat.fromJson(data);
        return cat;
      } else {
        debugPrint("[error] [CatService/fetchRandomCat] API response code: ${response.statusCode}");
        throw Exception('Data loading error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("[error] [CatService/fetchRandomCat] API request error: $e");
      throw Exception('API request error: $e');
    }
  }
}
