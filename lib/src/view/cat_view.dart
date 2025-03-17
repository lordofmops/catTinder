import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/presenter/cat_presenter.dart';
import 'cat_detail_screen.dart';

abstract class CatView {
  void updateCat(Cat cat);
}

class CatScreen extends StatefulWidget {
  @override
  _CatScreenState createState() => _CatScreenState();
}

class _CatScreenState extends State<CatScreen> implements CatView {
  late CatPresenter presenter;
  Cat? currentCat;
  int likes = 0;
  bool _isSwiping = false;
  double _swipeOffset = 0;
  double _startPosition = 0;

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

  void onLike() {
    if (_isSwiping) return;
    setState(() {
      likes++;
      _isSwiping = true;
    });
    presenter.loadRandomCat();
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
      body: Center(
        child: currentCat == null
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
                _swipeOffset = details.localPosition.dx - _startPosition;
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
                        builder: (context) => CatDetailScreen(cat: currentCat!),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      currentCat!.imageUrl,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
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
    );
  }
}


