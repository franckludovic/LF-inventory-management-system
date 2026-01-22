class ReportModel {
  final String id;
  final String type;
  final String userName;
  final String partName;
  final String locationName;
  final int quantity;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    required this.type,
    required this.userName,
    required this.partName,
    required this.locationName,
    required this.quantity,
    required this.createdAt,
  });

  // Factory constructor to create ReportModel from backend log data
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      userName: map['utilisateur'] != null ? map['utilisateur']['nom'] ?? '' : '',
      partName: map['composant'] != null ? map['composant']['designation'] ?? '' : '',
      locationName: map['sac'] != null ? map['sac']['nom'] ?? '' : '',
      quantity: map['quantite'] ?? 0,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
    );
  }
}
