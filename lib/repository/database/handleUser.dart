import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:get/get.dart';
import '../authentication/auth.dart';
import '../models/serviceModel.dart';
import '../models/userModel.dart';

class HandleUser extends GetxController {
  static HandleUser get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<UserModel>> getUsers() {
    return _db.collection("users").snapshots().map(
        (event) => event.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  Stream<List> pendingServices(String phone) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "pending" && element.clientPhone == phone)
        .toList());
  }

  Stream<List> inProcessServices(String phone) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "in process" &&
            element.clientPhone == phone)
        .toList());
  }

  Stream<List> completedServices(String phone) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "completed" &&
            element.clientPhone == phone)
        .toList());
  }

  Stream<List> feedbacks(String email) {
    return _db.collection("feedbacks").snapshots().map((event) =>
        event.docs.where((element) => element["email"] == email).toList());
  }
}
