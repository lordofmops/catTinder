class Cat {
  final String imageUrl;
  final String breed;
  final String weight;
  final String lifeSpan;
  final String temperament;
  final Map<String, int> ratings;
  final String? vetstreetUrl;
  final String? vcahospitalsUrl;
  final String? wikiUrl;
  final String? cfaUrl;

  Cat({
    required this.imageUrl,
    required this.breed,
    required this.weight,
    required this.lifeSpan,
    required this.temperament,
    required this.ratings,
    required this.vetstreetUrl,
    required this.vcahospitalsUrl,
    required this.wikiUrl,
    required this.cfaUrl
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      imageUrl: json['url'],
      breed: json['breeds'][0]['name'],
      weight: json['breeds'][0]['weight']['metric'],
      lifeSpan: json['breeds'][0]['life_span'],
      temperament: json['breeds'][0]['temperament'],
      vetstreetUrl: json['breeds'][0]['vetstreet_url'],
      vcahospitalsUrl: json['breeds'][0]['vcahospitals_url'],
      wikiUrl: json['breeds'][0]['wikipedia_url'],
      cfaUrl: json['breeds'][0]['cfa_url'],
      ratings: {
        "Adaptability": json['breeds'][0]['adaptability'],
        "Affection level": json['breeds'][0]['affection_level'],
        "Child friendly": json['breeds'][0]['child_friendly'],
        "Dog friendly": json['breeds'][0]['dog_friendly'],
        "Energy level": json['breeds'][0]['energy_level'],
        "Grooming": json['breeds'][0]['grooming'],
        "Health issues": json['breeds'][0]['health_issues'],
        "Intelligence": json['breeds'][0]['intelligence'],
        "Shedding level": json['breeds'][0]['shedding_level'],
        "Social needs": json['breeds'][0]['social_needs'],
        "Stranger friendly": json['breeds'][0]['stranger_friendly'],
        "Vocalisation": json['breeds'][0]['vocalisation'],
      },
    );
  }
}
