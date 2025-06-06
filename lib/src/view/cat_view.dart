import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/presenter/cat_presenter.dart';
import 'cat_detail_screen.dart';

abstract class CatView {
  void updateCat(Cat cat);
  void updateLikes(int likes);
  void showNetworkStatus(bool isConnected);
  void showError(String message);
}

class CatScreen extends StatefulWidget {
  const CatScreen({super.key});

  @override
  CatScreenState createState() => CatScreenState();
}

class CatScreenState extends State<CatScreen> implements CatView {
  late CatPresenter presenter;
  Cat? currentCat;
  int likes = 0;
  bool _isSwiping = false;
  double _swipeOffset = 0;
  double _startPosition = 0;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    presenter = CatPresenter(this);
    presenter.loadRandomCat();
  }

  @override
  void updateCat(Cat cat) {
    setState(() {
      currentCat = cat;
      _isSwiping = false;
      _swipeOffset = 0;
    });
    debugPrint("[info] [_CatScreenState/updateCat] Updated main screen");
  }

  @override
  void updateLikes(int likes) {
    setState(() {
      this.likes = likes;
    });
  }

  @override
  void showNetworkStatus(bool isConnected) {
    setState(() {
      _isConnected = isConnected;
    });

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection. Showing saved cats.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void onLike() {
    if (_isSwiping || currentCat == null) return;
    setState(() {
      _isSwiping = true;
    });
    presenter.handleLike(currentCat!);
  }

  void onDislike() {
    if (_isSwiping) return;
    setState(() {
      _isSwiping = true;
    });
    presenter.loadRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child:
              currentCat == null
                ? CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onPanStart: (details) {
                      _startPosition = details.localPosition.dx;
                  },
                  onPanUpdate: (details) {
                    if (_isSwiping) return;

                    setState(() {
                      _swipeOffset =
                          details.localPosition.dx - _startPosition;
                    });
                  },
                  onPanEnd: (details) {
                    if (_swipeOffset > 100) {
                      onLike();
                    } else if (_swipeOffset < -100) {
                      onDislike();
                    }

                    setState(() {
                      _isSwiping = false;
                      _swipeOffset = 0;
                    });
                  },

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "You liked $likes ${likes == 1 ? 'cat' : 'cats'} ❤️",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Source Sans Pro',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CatDetailScreen(cat: currentCat!),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: CachedNetworkImage(
                            imageUrl: currentCat!.imageUrl,
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              height: 300,
                              width: 300,
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        currentCat!.breed,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Source Sans Pro',
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: onDislike,
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap: onLike,
                            child: Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  ),
        ),
          if (!_isConnected)
            Positioned(
              top: 40,
              right: 20,
              child: Icon(
                Icons.wifi_off,
                color: Colors.red,
                size: 30,
              ),
            ),
        ],
      ),
    );
  }
}