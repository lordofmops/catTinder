import 'package:flutter/material.dart';
import 'package:cat_tinder/src/model/cat.dart';
import 'package:url_launcher/url_launcher.dart';

class CatDetailScreen extends StatelessWidget {
  final Cat cat;

  CatDetailScreen({required this.cat});

  Future<void> _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("[error] [CatDetailScreen/_launchURL] Could not launch $url");
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          cat.breed,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
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
                        height: 250,
                        width: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoBlock('Life span', '${cat.lifeSpan} yr'),
                        SizedBox(height: 8),
                        _buildInfoBlock('Weight', '${cat.weight} kg'),
                      ],
                    ),
                  ]
                ),
              ),
              SizedBox(height: 24),
              _buildDetailBlock('Temperament', cat.temperament.toLowerCase()),
              SizedBox(height: 24),
              _buildRatingsChart(cat.ratings),
              SizedBox(height: 24),
              Text(
                'Links',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Source Sans Pro',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              _buildLinkBlock('Vetstreet', cat.vetstreetUrl),
              _buildLinkBlock('Vcahospitals', cat.vcahospitalsUrl),
              _buildLinkBlock('Wikipedia', cat.wikiUrl),
              _buildLinkBlock('CFA', cat.cfaUrl),
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

  Widget _buildRatingsChart(Map<String, int> ratings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ratings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Source Sans Pro',
            color: Colors.black
          )
        ),
        SizedBox(height: 8),
        Column(
          children: ratings.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Source Sans Pro',
                        fontWeight: FontWeight.normal,
                        color: Colors.black
                      )
                    )
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(5)
                          )
                        ),
                        Container(
                          height: 10,
                          width: (entry.value / 5) * 300,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '${entry.value}/5',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Source Sans Pro',
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    )
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLinkBlock(String title, String? url) {
    return url == null
    ? SizedBox.shrink()
    : TextButton(
      onPressed: () => _launchURL(url),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 16,
          fontFamily: 'Source Sans Pro',
        ),
      ),
    );
  }
}
