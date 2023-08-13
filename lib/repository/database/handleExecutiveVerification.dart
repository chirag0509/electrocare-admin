import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../models/executiveVerificationModel.dart';

class HandleExecutiveVerification extends GetxController {
  static HandleExecutiveVerification get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<ExecutiveVerificationModel>> getApplications() {
    return _db
        .collection("executive_verification")
        .orderBy('time')
        .snapshots()
        .map((event) => event.docs
            .map((e) => ExecutiveVerificationModel.fromSnapshot(e))
            .where((element) => element.status == "pending")
            .toList());
  }

  Future<void> deleteApplication(String application) async {
    try {
      await FirebaseFirestore.instance
          .collection('executive_verification')
          .doc(application)
          .delete();
    } catch (error) {
      print("Error deleting application: $error");
    }
  }

  Future<void> updateApplication(ExecutiveVerificationModel application) async {
    try {
      await FirebaseFirestore.instance
          .collection('executive_verification')
          .doc(application.id)
          .update(application.toJson());
    } catch (error) {
      print("Error updating application: $error");
    }
  }
}
