import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cat_tinder/src/model/cat.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;

  static const _likesKey = 'likes_count';
  static const _databaseName = 'CatsDatabase.db';
  static const _databaseVersion = 3;
  static const _catsTable = 'cats';

  LocalStorage._internal();

  late Database _db;

  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_catsTable (
        id TEXT PRIMARY KEY,
        imageUrl TEXT NOT NULL,
        breed TEXT NOT NULL,
        weight TEXT NOT NULL,
        lifeSpan TEXT NOT NULL,
        origin TEXT NOT NULL,
        temperament TEXT NOT NULL,
        description TEXT NOT NULL,
        vetstreetUrl TEXT,
        vcahospitalsUrl TEXT,
        wikiUrl TEXT,
        cfaUrl TEXT,
        socialAttributes TEXT NOT NULL,
        activityAndCareAttributes TEXT NOT NULL,
        physicalAttributes TEXT NOT NULL,
        rarityAttributes TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        is_liked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute('ALTER TABLE $_catsTable ADD COLUMN is_liked INTEGER NOT NULL DEFAULT 0');
      } catch (e) {
        debugPrint('Migration error: $e');
      }
    }
  }

  Future<bool> saveLikes(int likes) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_likesKey, likes);
  }

  Future<int> getLikes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_likesKey) ?? 0;
  }

  Future<List<Cat>> getLikedCats() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      _catsTable,
      where: 'is_liked = ?',
      whereArgs: [1],
      orderBy: 'timestamp DESC',
    );
    return _convertMapsToCats(maps);
  }

  Future<void> saveCat(Cat cat, {bool liked = false}) async {
    await _db.insert(
      _catsTable,
      {
        'id': '${cat.imageUrl.hashCode}',
        'imageUrl': cat.imageUrl,
        'breed': cat.breed,
        'weight': cat.weight,
        'lifeSpan': cat.lifeSpan,
        'origin': cat.origin,
        'temperament': cat.temperament,
        'description': cat.description,
        'vetstreetUrl': cat.vetstreetUrl,
        'vcahospitalsUrl': cat.vcahospitalsUrl,
        'wikiUrl': cat.wikiUrl,
        'cfaUrl': cat.cfaUrl,
        'socialAttributes': _mapToJson(cat.socialAttributes),
        'activityAndCareAttributes': _mapToJson(
            cat.activityAndCareAttributes),
        'physicalAttributes': _mapToJson(cat.physicalAttributes),
        'rarityAttributes': _mapToJson(cat.rarityAttributes),
        'timestamp': DateTime
            .now()
            .millisecondsSinceEpoch,
        'is_liked': liked ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    if (liked) {
      await _db.update(
        _catsTable,
        {'is_liked': 1},
        where: 'id = ?',
        whereArgs: ['${cat.imageUrl.hashCode}'],
      );
      debugPrint("[info] [LocalStorage/saveCat] Cat saved to favorites");
    }
  }

  Future<List<Cat>> getSavedCats() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      _catsTable,
      orderBy: 'timestamp DESC',
    );
    return _convertMapsToCats(maps);
  }

  String _mapToJson(Map<String, int> map) {
    return map.entries.map((e) => '${e.key}:${e.value}').join(';');
  }

  Map<String, int> _jsonToMap(String json) {
    final Map<String, int> result = {};
    json.split(';').forEach((pair) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        result[parts[0]] = int.parse(parts[1]);
      }
    });
    return result;
  }

  List<Cat> _convertMapsToCats(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Cat(
        imageUrl: maps[i]['imageUrl'],
        breed: maps[i]['breed'],
        weight: maps[i]['weight'],
        lifeSpan: maps[i]['lifeSpan'],
        origin: maps[i]['origin'],
        temperament: maps[i]['temperament'],
        description: maps[i]['description'],
        vetstreetUrl: maps[i]['vetstreetUrl'],
        vcahospitalsUrl: maps[i]['vcahospitalsUrl'],
        wikiUrl: maps[i]['wikiUrl'],
        cfaUrl: maps[i]['cfaUrl'],
        socialAttributes: _jsonToMap(maps[i]['socialAttributes']),
        activityAndCareAttributes: _jsonToMap(maps[i]['activityAndCareAttributes']),
        physicalAttributes: _jsonToMap(maps[i]['physicalAttributes']),
        rarityAttributes: _jsonToMap(maps[i]['rarityAttributes']),
        isLiked: maps[i]['is_liked'] == 1,
      );
    });
  }
}