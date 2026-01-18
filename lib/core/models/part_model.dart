class PartModel {
  final String name;
  final String brand;
  final String quantity;
  final String location;
  final String imageUrl;
  final bool isLowStock;
  final String? referenceNumber;
  final String? description;
  final List<Map<String, String>>? locations;

  const PartModel({
    required this.name,
    required this.brand,
    required this.quantity,
    required this.location,
    required this.imageUrl,
    this.isLowStock = false,
    this.referenceNumber,
    this.description,
    this.locations,
  });

  // Factory constructor to create PartModel from the existing map data
  factory PartModel.fromMap(Map<String, dynamic> map) {
    return PartModel(
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      quantity: map['quantity'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isLowStock: map['isLowStock'] ?? false,
      referenceNumber: map['referenceNumber'],
      description: map['description'],
      locations: map['locations'] != null ? List<Map<String, String>>.from(map['locations']) : null,
    );
  }
}
