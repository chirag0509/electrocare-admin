import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String? id;
  final String name;
  final String email;
  final String password;

  const AdminModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
    };
  }

  factory AdminModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return AdminModel(
      id: document.id,
      name: data["name"],
      email: data["email"],
      password: data["password"],
    );
  }
}
