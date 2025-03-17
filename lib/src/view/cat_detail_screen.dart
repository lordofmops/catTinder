import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  CatDetailScreen({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: Offset(-30, 0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        cat.imageUrl,
                        height: 220,
                        width: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoBlock('Life Span', '${cat.lifeSpan} yr'),
                        SizedBox(height: 8),
                        _buildInfoBlock('Weight', '${cat.weight} kg'),
                      ],
                    ),
                  ]
                ),
              ),
              SizedBox(height: 24),
              _buildDetailBlock('Breed', cat.breed),
              SizedBox(height: 16),
              _buildDetailBlock('Temperament', cat.temperament),
            ],
          ),
        )

      ),
    );
  }

  Widget _buildInfoBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.normal,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
