import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:electrocare_admin/repository/models/serviceModel.dart';
import 'package:get/get.dart';
import '../authentication/auth.dart';

class HandleServices extends GetxController {
  static HandleServices get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List> pendingServices() {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) => element.serviceStatus == "pending")
        .toList());
  }

  Stream<List> inProcessServices() {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) => element.serviceStatus == "in process")
        .toList());
  }

  Stream<List> completedServices() {
    return _db.collection("services").snapshots().map((event) => event.docs
        .map((e) => ServiceModel.fromSnapshot(e))
        .where((element) => element.serviceStatus == "completed")
        .toList());
  }

  Stream<List<ServiceModel>> notAssignedServices() {
    return _db.collection("services").orderBy("time").snapshots().map((event) =>
        event.docs
            .map((e) => ServiceModel.fromSnapshot(e))
            .where((element) => element.executive == "not assigned")
            .toList());
  }

  Future<void> updateService(String id, ServiceModel service) async {
    await _db.collection("services").doc(id).update(service.toJson());
  }
}
