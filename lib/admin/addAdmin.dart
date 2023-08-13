import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/admin/allAdmins.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/controller/formController.dart';
import 'package:electrocare_admin/repository/database/handleAdmin.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../repository/authentication/auth.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({super.key});

  @override
  State<AddAdmin> createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  final color = ColorController.instance;
  final adminController = Get.put(HandleAdmin());
  final fi = FormController.instance;
  final _fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _fromKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      "Add Admin",
                      style: TextStyle(
                          fontSize: w * 0.06, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: fi.name,
                      style: TextStyle(fontSize: w * 0.04),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Name",
                          hintText: "Enter a name",
                          labelStyle: TextStyle(fontSize: w * 0.04),
                          hintStyle: TextStyle(fontSize: w * 0.04),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: fi.email,
                      style: TextStyle(fontSize: w * 0.04),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Email",
                          hintText: "Enter an email",
                          labelStyle: TextStyle(fontSize: w * 0.04),
                          hintStyle: TextStyle(fontSize: w * 0.04),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextFormField(
                      controller: fi.password,
                      style: TextStyle(fontSize: w * 0.04),
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: "Password",
                          hintText: "Enter a password",
                          labelStyle: TextStyle(fontSize: w * 0.04),
                          hintStyle: TextStyle(fontSize: w * 0.04),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10)),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10))),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_fromKey.currentState!.validate()) {
                        final adminDoc = await FirebaseFirestore.instance
                            .collection("admins")
                            .doc(Auth.instance.firebaseUser.value!.email)
                            .get();
                        final email = adminDoc.get('email');
                        final password = adminDoc.get('password');
                        Auth.instance.createUserWithEmailAndPassword(
                            fi.email.text,
                            fi.password.text,
                            email,
                            password,
                            context);

                        await FirebaseFirestore.instance
                            .collection("admins")
                            .doc(fi.email.text)
                            .set({
                          "name": fi.name.text,
                          "email": fi.email.text,
                          "password": fi.password.text,
                        });

                        Get.showSnackbar(
                          GetSnackBar(
                            message: "Admin added successfully.",
                            duration: Duration(seconds: 2),
                            backgroundColor: Color.fromARGB(255, 35, 35, 35),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: color.black,
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: w * 0.045,
                              fontWeight: FontWeight.w500,
                              color: color.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
