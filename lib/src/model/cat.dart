class Cat {
  final String imageUrl;
  final String breed;
  final String weight;
  final String lifeSpan;
  final String origin;
  final String temperament;
  final String description;
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
    required this.origin,
    required this.temperament,
    required this.description,
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
      origin: json['breeds'][0]['country_code'],
      temperament: json['breeds'][0]['temperament'],
      description: json['breeds'][0]['description'],
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
        "Experimental": json['breeds'][0]['experimental'],
        "Hairless": json['breeds'][0]['hairless'],
        "Natural": json['breeds'][0]['natural'],
        "Rare": json['breeds'][0]['rare'],
        "Rex": json['breeds'][0]['rex'],
        "Suppressed tail": json['breeds'][0]['suppressed_tail'],
        "Short legs": json['breeds'][0]['short_legs'],
        "Hypoallergenic": json['breeds'][0]['hypoallergenic'],
      },
    );
  }
}
