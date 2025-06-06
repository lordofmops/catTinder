import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/service/local_storage.dart';
import 'cat_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final LocalStorage _storage = LocalStorage();
  List<Cat> _favoriteCats = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    await _storage.init();
    final cats = await _storage.getLikedCats();
    setState(() {
      _favoriteCats = cats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Favorite Cats'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _favoriteCats.isEmpty
          ? Center(
        child: Text(
          'No favorite cats yet',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      )
          : ListView.builder(
        itemCount: _favoriteCats.length,
        itemBuilder: (context, index) {
          final cat = _favoriteCats[index];
          return ListTile(
            leading: CachedNetworkImage(
              imageUrl: cat.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(
              cat.breed,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              cat.origin,
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatDetailScreen(cat: cat),
                ),
              );
            },
          );
        },
      ),
    );
  }
}