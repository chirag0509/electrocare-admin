import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/admin/addComponent.dart';
import 'package:electrocare_admin/repository/authentication/auth.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/database/handleExecutive.dart';
import 'package:electrocare_admin/repository/database/handleExecutiveVerification.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:electrocare_admin/repository/models/executiveModel.dart';
import 'package:electrocare_admin/repository/models/executiveVerificationModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EVerify extends StatefulWidget {
  const EVerify({super.key});

  @override
  State<EVerify> createState() => _EVerifyState();
}

class _EVerifyState extends State<EVerify> {
  final applicationController = Get.put(HandleExecutiveVerification());
  final executiveController = Get.put(HandleExecutive());

  Future<void> deleteApplication(
      String application, String id_front, String id_back) async {
    try {
      // Delete from Firestore collection
      await applicationController.deleteApplication(application);

      // Delete from Firebase Storage
      if (id_front.isNotEmpty) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(id_front);
        await storageRef.delete();
      }
      if (id_back.isNotEmpty) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(id_back);
        await storageRef.delete();
      }
    } catch (error) {
      print("Error deleting component: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    "Appliactions",
                    style: TextStyle(
                      fontSize: w * 0.04,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<List<ExecutiveVerificationModel>>(
                stream: applicationController.getApplications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!.length == 0
                        ? Center(
                            child: Text("You do not have any applications."),
                          )
                        : ListView.builder(
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].name.capitalize}",
                                                  style: TextStyle(
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${snapshot.data![index].email.capitalize}",
                                                  style: TextStyle(
                                                      fontSize: w * 0.035,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                        return AlertDialog(
                                                          scrollable: true,
                                                          elevation: 3,
                                                          title: Center(
                                                            child: Text(snapshot
                                                                .data![index]
                                                                .name
                                                                .capitalize
                                                                .toString()),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Text("Email : " +
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .email),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Text("DOB : " +
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .dob),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Text("Address : " +
                                                                    snapshot
                                                                        .data![
                                                                            index]
                                                                        .address),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Text(
                                                                    "JobType :"),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Wrap(
                                                                  spacing: 8,
                                                                  children: snapshot
                                                                      .data![
                                                                          index]
                                                                      .jobType
                                                                      .map(
                                                                          (value) {
                                                                    return Chip(
                                                                      label: Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child: Text(
                                                                    "Identity :"),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            8),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return Dialog(
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: snapshot.data![index].id_front,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            100,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: snapshot
                                                                              .data![index]
                                                                              .id_front,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            8),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return Dialog(
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: snapshot.data![index].id_back,
                                                                                fit: BoxFit.contain,
                                                                              ),
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            100,
                                                                        width:
                                                                            100,
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: snapshot
                                                                              .data![index]
                                                                              .id_back,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red,
                                                                        elevation:
                                                                            3),
                                                                    onPressed:
                                                                        () async {
                                                                      await deleteApplication(
                                                                          snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id!,
                                                                          snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id_front,
                                                                          snapshot
                                                                              .data![index]
                                                                              .id_back);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Get.showSnackbar(
                                                                        GetSnackBar(
                                                                          message:
                                                                              "Application rejected.",
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              35,
                                                                              35,
                                                                              35),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Text(
                                                                      'Reject',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                            elevation:
                                                                                3),
                                                                    onPressed:
                                                                        () async {
                                                                      final application = ExecutiveVerificationModel(
                                                                          id: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id,
                                                                          name: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .name,
                                                                          email: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .email,
                                                                          dob: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .dob,
                                                                          address: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .address,
                                                                          jobType: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .jobType,
                                                                          id_front: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id_front,
                                                                          id_back: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .id_back,
                                                                          status:
                                                                              "approved",
                                                                          time:
                                                                              Timestamp.now());
                                                                      await applicationController
                                                                          .updateApplication(
                                                                              application);

                                                                      String
                                                                          newEmail =
                                                                          modifyEmail(snapshot
                                                                              .data![index]
                                                                              .email);
                                                                      final adminDoc = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "admins")
                                                                          .doc(Auth
                                                                              .instance
                                                                              .firebaseUser
                                                                              .value!
                                                                              .email)
                                                                          .get();
                                                                      final email =
                                                                          adminDoc
                                                                              .get('email');
                                                                      final password =
                                                                          adminDoc
                                                                              .get('password');
                                                                      Auth.instance.createUserWithEmailAndPassword(
                                                                          newEmail,
                                                                          "12345678",
                                                                          email,
                                                                          password,
                                                                          context);
                                                                      Get.showSnackbar(
                                                                        GetSnackBar(
                                                                          message:
                                                                              "Executive added successfully.",
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              35,
                                                                              35,
                                                                              35),
                                                                        ),
                                                                      );
                                                                      final executive = ExecutiveModel(
                                                                          name: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .name,
                                                                          email:
                                                                              newEmail,
                                                                          dob: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .dob,
                                                                          address: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .address,
                                                                          jobType: snapshot
                                                                              .data![
                                                                                  index]
                                                                              .jobType,
                                                                          password:
                                                                              "12345678");

                                                                      await executiveController
                                                                          .addExecutive(
                                                                              executive);

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                      'Approve',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3, horizontal: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey)),
                                                child: Text(
                                                  "View Application",
                                                  style: TextStyle(
                                                    fontSize: w * 0.035,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String modifyEmail(String email) {
  List<String> parts = email.split('@');

  parts[1] = 'electrocare.com';

  return parts.join('@');
}
