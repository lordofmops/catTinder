import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';
import 'package:cat_tinder/src/presenter/cat_presenter.dart';
import 'package:cat_tinder/src/widgets/like_dislike_buttons.dart';
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
    print("Обновляем UI: ${cat.imageUrl}, ${cat.breed}");
    setState(() {
      currentCat = cat;
      _isSwiping = false;
      _swipeOffset = 0;
    });
  }

  void onLike() {
    if (_isSwiping) return;
    setState(() {
      likes++;
      _isSwiping = true;
    });
    print("Пользователь лайкнул котика");
    presenter.loadRandomCat();
  }

  void onDislike() {
    if (_isSwiping) return;
    setState(() {
      _isSwiping = true;
    });
    print("Пользователь дизлайкнул котика :(");
    presenter.loadRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Кототиндер ($likes ❤️)')),
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
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      currentCat!.imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  currentCat!.breed,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                LikeDislikeButtons(onLike: onLike, onDislike: onDislike),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

