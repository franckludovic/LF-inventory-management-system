class UserModel {
  final String id;
  final String nom;
  final String email;
  final String motDePasse;
  final String? department;
  final String region;
  final String ville;
  final List<String> role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.nom,
    required this.email,
    required this.motDePasse,
    this.department,
    required this.region,
    required this.ville,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create UserModel from backend utilisateur data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      email: map['email'] ?? '',
      motDePasse: map['motDePasse'] ?? '',
      department: map['Department'],
      region: map['region'] ?? '',
      ville: map['ville'] ?? '',
      role: map['role'] is List ? List<String>.from(map['role']) : [],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }
}
