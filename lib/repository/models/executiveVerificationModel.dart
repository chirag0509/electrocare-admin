import 'package:cloud_firestore/cloud_firestore.dart';

class ExecutiveVerificationModel {
  final String? id;
  final String name;
  final String email;
  final String dob;
  final String address;
  final Set<String> jobType;
  final String id_front;
  final String id_back;
  final String status;
  final Timestamp time;

  const ExecutiveVerificationModel({
    this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.address,
    required this.jobType,
    required this.id_front,
    required this.id_back,
    required this.status,
    required this.time,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "dob": dob,
      "address": address,
      "jobType": jobType.toList(),
      "id_front": id_front,
      "id_back": id_back,
      "status": status,
      "time": time,
    };
  }

  factory ExecutiveVerificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ExecutiveVerificationModel(
      id: document.id,
      name: data["name"],
      email: data["email"],
      dob: data["dob"],
      address: data["address"],
      jobType: (data["jobType"] as List<dynamic>).cast<String>().toSet(),
      id_front: data["id_front"],
      id_back: data["id_back"],
      status: data["status"],
      time: data["time"],
    );
  }
}
