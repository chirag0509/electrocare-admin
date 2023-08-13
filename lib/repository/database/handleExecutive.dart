import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:electrocare_admin/repository/models/executiveModel.dart';
import 'package:get/get.dart';
import '../authentication/auth.dart';
import '../models/serviceModel.dart';

class HandleExecutive extends GetxController {
  static HandleExecutive get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<ExecutiveModel>> getExecutives() {
    return _db.collection("executives").snapshots().map((event) =>
        event.docs.map((e) => ExecutiveModel.fromSnapshot(e)).toList());
  }

  Future<void> addExecutive(ExecutiveModel executive) async {
    try {
      await _db
          .collection("executives")
          .doc(executive.email)
          .set(executive.toJson());
    } catch (e) {
      print(e);
    }
  }

  Stream<List> pendingServices(String email) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "pending" && element.executiveID == email)
        .toList());
  }

  Stream<List> inProcessServices(String email) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "in process" &&
            element.executiveID == email)
        .toList());
  }

  Stream<List> completedServices(String email) {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) =>
            element.serviceStatus == "completed" &&
            element.executiveID == email)
        .toList());
  }
}
