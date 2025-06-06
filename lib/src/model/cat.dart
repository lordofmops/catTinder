class Cat {
  final String imageUrl;
  final String breed;
  final String weight;
  final String lifeSpan;
  final String origin;
  final String temperament;
  final String description;
  final Map<String, int> socialAttributes;
  final Map<String, int> activityAndCareAttributes;
  final Map<String, int> physicalAttributes;
  final Map<String, int> rarityAttributes;
  final String? vetstreetUrl;
  final String? vcahospitalsUrl;
  final String? wikiUrl;
  final String? cfaUrl;
  final bool isLiked;

  Cat({
    required this.imageUrl,
    required this.breed,
    required this.weight,
    required this.lifeSpan,
    required this.origin,
    required this.temperament,
    required this.description,
    required this.socialAttributes,
    required this.activityAndCareAttributes,
    required this.physicalAttributes,
    required this.rarityAttributes,
    required this.vetstreetUrl,
    required this.vcahospitalsUrl,
    required this.wikiUrl,
    required this.cfaUrl,
    this.isLiked = false,
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
      socialAttributes: {
        "Affection level": json['breeds'][0]['affection_level'],
        "Child friendly": json['breeds'][0]['child_friendly'],
        "Dog friendly": json['breeds'][0]['dog_friendly'],
        "Stranger friendly": json['breeds'][0]['stranger_friendly'],
        "Social needs": json['breeds'][0]['social_needs'],
        "Vocalisation": json['breeds'][0]['vocalisation'],
        "Intelligence": json['breeds'][0]['intelligence'],
      },
      activityAndCareAttributes: {
        "Energy level": json['breeds'][0]['energy_level'],
        "Adaptability": json['breeds'][0]['adaptability'],
        "Grooming": json['breeds'][0]['grooming'],
        "Shedding level": json['breeds'][0]['shedding_level'],
        "Health issues": json['breeds'][0]['health_issues'],
      },
      rarityAttributes: {
        "Experimental/Established": json['breeds'][0]['experimental'],
        "Natural/Selective": json['breeds'][0]['natural'],
        "Rare/Common": json['breeds'][0]['rare'],
      },
      physicalAttributes: {
        "Hairless/Furry": json['breeds'][0]['hairless'],
        "Short legs/Long legs": json['breeds'][0]['short_legs'],
        "Rex/Straight coat": json['breeds'][0]['rex'],
        "Suppressed/Full tail": json['breeds'][0]['suppressed_tail'],
        "Hypoallergenic/Allergenic": json['breeds'][0]['hypoallergenic'],
      },
    );
  }

  Cat copyWith({
    String? imageUrl,
    String? breed,
    String? weight,
    String? lifeSpan,
    String? origin,
    String? temperament,
    String? description,
    Map<String, int>? socialAttributes,
    Map<String, int>? activityAndCareAttributes,
    Map<String, int>? physicalAttributes,
    Map<String, int>? rarityAttributes,
    String? vetstreetUrl,
    String? vcahospitalsUrl,
    String? wikiUrl,
    String? cfaUrl,
    bool? isLiked,
  }) {
    return Cat(
      imageUrl: imageUrl ?? this.imageUrl,
      breed: breed ?? this.breed,
      weight: weight ?? this.weight,
      lifeSpan: lifeSpan ?? this.lifeSpan,
      origin: origin ?? this.origin,
      temperament: temperament ?? this.temperament,
      description: description ?? this.description,
      socialAttributes: socialAttributes ?? this.socialAttributes,
      activityAndCareAttributes: activityAndCareAttributes ?? this.activityAndCareAttributes,
      physicalAttributes: physicalAttributes ?? this.physicalAttributes,
      rarityAttributes: rarityAttributes ?? this.rarityAttributes,
      vetstreetUrl: vetstreetUrl ?? this.vetstreetUrl,
      vcahospitalsUrl: vcahospitalsUrl ?? this.vcahospitalsUrl,
      wikiUrl: wikiUrl ?? this.wikiUrl,
      cfaUrl: cfaUrl ?? this.cfaUrl,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
