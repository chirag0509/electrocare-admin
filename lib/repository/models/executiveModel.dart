import 'package:cloud_firestore/cloud_firestore.dart';

class ExecutiveModel {
  final String? id;
  final String name;
  final String email;
  final String dob;
  final Set<String> jobType;
  final String address;
  final String password;

  const ExecutiveModel({
    this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.address,
    required this.jobType,
    required this.password,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "dob": dob,
      "address": address,
      "jobType": jobType.toList(),
      "password": password,
    };
  }

  factory ExecutiveModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ExecutiveModel(
      id: document.id,
      name: data["name"],
      email: data["email"],
      dob: data["dob"],
      address: data["address"],
      jobType: (data["jobType"] as List<dynamic>).cast<String>().toSet(),
      password: data["password"],
    );
  }
}
