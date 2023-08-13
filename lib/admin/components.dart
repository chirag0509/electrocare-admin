import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/admin/addComponent.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Components extends StatefulWidget {
  const Components({super.key});

  @override
  State<Components> createState() => _ComponentsState();
}

class _ComponentsState extends State<Components> {
  final componentController = Get.put(HandleComponent());

  Future<void> deleteComponent(String componentId, String imageUrl) async {
    try {
      // Delete from Firestore collection
      await componentController.deleteComponent(componentId);

      // Delete from Firebase Storage
      if (imageUrl.isNotEmpty) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Show a success message or perform any other necessary actions
    } catch (error) {
      // Handle errors
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
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => AddComponent());
                      },
                      child: Text(
                        "+ Add Component",
                        style: TextStyle(
                          fontSize: w * 0.04,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<List<ComponentModel>>(
                stream: componentController.getComponents(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0
                        ? Center(
                            child: Text("You do not have any components."),
                          )
                        : ListView.builder(
                            itemCount: data.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final mrc = TextEditingController(
                                  text: snapshot.data![index].mrc);
                              final msc = TextEditingController(
                                  text: snapshot.data![index].msc);
                              final sc = TextEditingController(
                                  text: snapshot.data![index].sc);
                              final dc = TextEditingController(
                                  text: snapshot.data![index].dc);

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
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: CachedNetworkImage(
                                                  imageUrl: data[index].image),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${snapshot.data![index].id!.capitalize}",
                                                  style: TextStyle(
                                                      fontSize: w * 0.04,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${snapshot.data![index].category.capitalize}",
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
                                                                .id!
                                                                .capitalize
                                                                .toString()),
                                                          ),
                                                          content: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      mrc,
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.04),
                                                                  decoration: InputDecoration(
                                                                      alignLabelWithHint:
                                                                          true,
                                                                      labelText:
                                                                          "Minimum Repair Charge",
                                                                      hintText:
                                                                          "Enter Minimum Repair Charge",
                                                                      labelStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      hintStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              18),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Colors
                                                                                  .grey.shade300),
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10))),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      msc,
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.04),
                                                                  decoration: InputDecoration(
                                                                      alignLabelWithHint:
                                                                          true,
                                                                      labelText:
                                                                          "Minimum Service Charge",
                                                                      hintText:
                                                                          "Enter Minimum Service Charge",
                                                                      labelStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      hintStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              18),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Colors
                                                                                  .grey.shade300),
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10))),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      sc,
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.04),
                                                                  decoration: InputDecoration(
                                                                      alignLabelWithHint:
                                                                          true,
                                                                      labelText:
                                                                          "Setup Charge",
                                                                      hintText:
                                                                          "Enter Setup Charge",
                                                                      labelStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      hintStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              18),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Colors
                                                                                  .grey.shade300),
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10))),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        8),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      dc,
                                                                  style: TextStyle(
                                                                      fontSize: w *
                                                                          0.04),
                                                                  decoration: InputDecoration(
                                                                      alignLabelWithHint:
                                                                          true,
                                                                      labelText:
                                                                          "Delivery Charge",
                                                                      hintText:
                                                                          "Enter Delivery Charge",
                                                                      labelStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      hintStyle: TextStyle(
                                                                          fontSize: w *
                                                                              0.04),
                                                                      contentPadding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              20,
                                                                          vertical:
                                                                              18),
                                                                      enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1,
                                                                              color: Colors
                                                                                  .grey.shade300),
                                                                          borderRadius: BorderRadius.circular(
                                                                              10)),
                                                                      border: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              width:
                                                                                  1),
                                                                          borderRadius:
                                                                              BorderRadius.circular(10))),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    1,
                                                                child:
                                                                    ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          elevation:
                                                                              3),
                                                                  onPressed:
                                                                      () async {
                                                                    final updateComp = ComponentModel(
                                                                        category: snapshot
                                                                            .data![
                                                                                index]
                                                                            .category,
                                                                        image: snapshot
                                                                            .data![
                                                                                index]
                                                                            .image,
                                                                        mrc: mrc
                                                                            .text,
                                                                        msc: msc
                                                                            .text,
                                                                        sc: sc
                                                                            .text,
                                                                        dc: dc
                                                                            .text);
                                                                    await componentController.updateComponent(
                                                                        snapshot
                                                                            .data![index]
                                                                            .id!,
                                                                        updateComp);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.showSnackbar(
                                                                      GetSnackBar(
                                                                        message:
                                                                            "Pricing updated successfully.",
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
                                                                    'Submit',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ),
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
                                                  "Edit",
                                                  style: TextStyle(
                                                    fontSize: w * 0.035,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Confirm delete component?"),
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .grey),
                                                                child: Text(
                                                                    "Close")),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  await deleteComponent(
                                                                      data[index]
                                                                          .id!,
                                                                      data[index]
                                                                          .image);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Get.showSnackbar(
                                                                    GetSnackBar(
                                                                      message:
                                                                          "Component deleted successfully.",
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              35,
                                                                              35,
                                                                              35),
                                                                    ),
                                                                  );
                                                                },
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .red),
                                                                child: Text(
                                                                    "Delete")),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                  size: w * 0.045,
                                                ))
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
