import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/admin/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes.dart';

class Auth extends GetxController {
  static Auth get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(_auth.currentUser!.email)
        .get();
    if (user != null) {
      if (userDoc.exists) {
        Get.offAllNamed(UserRoutes.dashboard);
      }
    } else {
      Get.offAllNamed(MyRoutes.home);
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                  height: 100,
                  width: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  )),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.showSnackbar(
          GetSnackBar(
            message: "No user found for that email.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
          ),
        );
      } else if (e.code == 'wrong-password') {
        Get.showSnackbar(
          GetSnackBar(
            message: "Please check the password you entered.",
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 35, 35, 35),
          ),
        );
      }
    }
  }

  Future<void> logout() async =>
      await _auth.signOut().then((_) => Get.toNamed(MyRoutes.home));

  Future<void> createUserWithEmailAndPassword(String email, String password,
      String adminEmail, String adminPassword, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Auth.instance
          .signInWithEmailAndPassword(adminEmail, adminPassword, context);

      print('User created successfully');
    } catch (e) {
      print('Error creating user: $e');
    }
  }
}
