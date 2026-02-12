class LocationModel {
  final String? id;
  final String name;
  final int? maxQuantity;
  final int totalQuantity;

  const LocationModel({
    this.id,
    required this.name,
    this.maxQuantity,
    this.totalQuantity = 0,
  });

  // Factory constructor to create LocationModel from backend sac data
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id']?.toString(),
      name: map['nom'] ?? '',
      maxQuantity: map['capaciteMax'],
      totalQuantity: map['quantite_total'] ?? 0,
    );
  }


  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'maxQuantity': maxQuantity,
      'totalQuantity': totalQuantity,
    };
  }

  // Copy with
  LocationModel copyWith({
    String? name,
    int? maxQuantity,
    int? totalQuantity,
  }) {
    return LocationModel(
      name: name ?? this.name,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      totalQuantity: totalQuantity ?? this.totalQuantity,
    );
  }
}
