class PartModel {
  final String id;
  final String name;
  final String brand;
  final String quantity;
  final String location;
  final String imageUrl;
  final bool isLowStock;
  final String? referenceNumber;
  final String? description;
  final List<Map<String, String>>? locations;
  final String? publicId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PartModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.quantity,
    required this.location,
    required this.imageUrl,
    this.isLowStock = false,
    this.referenceNumber,
    this.description,
    this.locations,
    this.publicId,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create PartModel from backend composant data
  factory PartModel.fromMap(Map<String, dynamic> map) {
    // Calculate total quantity and locations from sacComposants
    int totalQuantity = 0;
    List<Map<String, String>> locationList = [];
    String locationString = '';

    if (map['sacComposants'] != null) {
      List<dynamic> sacComposants = map['sacComposants'];
      for (var sacComp in sacComposants) {
        int quantite = sacComp['quantite'] ?? 0;
        totalQuantity += quantite;

        if (sacComp['sac'] != null) {
          String sacName = sacComp['sac']['nom'] ?? '';
          locationList.add({sacName: quantite.toString()});
          if (locationString.isNotEmpty) locationString += ', ';
          locationString += '$sacName ($quantite)';
        }
      }
    }

    return PartModel(
      id: map['id'] ?? '',
      name: map['designation'] ?? '',
      brand: map['fabriquant'] ?? '',
      quantity: totalQuantity.toString(),
      location: locationString.isNotEmpty ? locationString : 'No location',
      imageUrl: map['imageUrl'] ?? '',
      isLowStock: totalQuantity < 5, // Consider low stock if less than 5
      referenceNumber: map['reference'],
      description: map['description'],
      locations: locationList.isNotEmpty ? locationList : null,
      publicId: map['publicId'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
