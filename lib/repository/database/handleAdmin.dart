import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:get/get.dart';
import '../authentication/auth.dart';

class HandleAdmin extends GetxController {
  static HandleAdmin get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = Auth.instance;

  Stream<AdminModel> getAdminDetails() {
    return _db.collection("admins").snapshots().map((event) => event.docs
        .map((e) => AdminModel.fromSnapshot(e))
        .singleWhere(
            (user) => user.email == Auth.instance.firebaseUser.value!.email));
  }

  Stream<List> getAdmins() {
    return _db.collection("admins").snapshots().map((event) => event.docs
        .where((element) => element["email"] != _auth.firebaseUser.value!.email)
        .toList());
  }
}
