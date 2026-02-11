class PartModel {
  final String id;
  final String designation;
  final String fabriquant;
  final String quantity;
  final String location;
  final String imageUrl;
  final bool isLowStock;
  final String? reference;
  final String? description;
  final List<Map<String, String>>? locations;
  final String? publicId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Helper getters for stock status
  bool get isCriticalStock => (int.tryParse(quantity) ?? 0) <= 2; // Critical: 2 or less
  bool get isLowStockStatus => (int.tryParse(quantity) ?? 0) <= 5; // Low: 5 or less

  const PartModel({
    required this.id,
    required this.designation,
    required this.fabriquant,
    required this.quantity,
    required this.location,
    required this.imageUrl,
    this.isLowStock = false,
    this.reference,
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
      designation: map['designation'] ?? '',
      fabriquant: map['fabriquant'] ?? '',
      quantity: totalQuantity.toString(),
      location: locationString.isNotEmpty ? locationString : 'No location',
      imageUrl: map['imageUrl'] ?? '',
      isLowStock: totalQuantity <= 5, // Low stock: 5 or less
      reference: map['reference'],
      description: map['description'],
      locations: locationList.isNotEmpty ? locationList : null,
      publicId: map['publicId'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
