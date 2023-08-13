import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:get/get.dart';
import '../authentication/auth.dart';

class HandleComponent extends GetxController {
  static HandleComponent get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Stream<List<ComponentModel>> getComponents() {
    return _db.collection("components").snapshots().map((event) =>
        event.docs.map((e) => ComponentModel.fromSnapshot(e)).toList());
  }

  Future<void> addComponent(String compID, ComponentModel comp) async {
    await _db.collection("components").doc(compID).set(comp.toJson());
  }

  Future<void> deleteComponent(String componentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('components')
          .doc(componentId)
          .delete();

      // You can also handle additional cleanup or logging here if needed
    } catch (error) {
      // Handle errors
      print("Error deleting component: $error");
    }
  }

  Future<void> updateComponent(String compID, ComponentModel comp) async {
    await _db.collection("components").doc(compID).update(comp.toJson());
  }
}
