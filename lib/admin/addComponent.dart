import 'dart:io';

import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddComponent extends StatefulWidget {
  const AddComponent({super.key});

  @override
  State<AddComponent> createState() => _AddComponentState();
}

class _AddComponentState extends State<AddComponent> {
  final color = ColorController.instance;
  final componentController = Get.put(HandleComponent());

  String imageUrl = "";
  ImagePicker imagePicker = ImagePicker();
  XFile? file;
  void pickImage() async {
    file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    } else {
      setState(() {});
    }
  }

  Future<void> uploadImage() async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child("components");
    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);
    try {
      await referenceImagesToUpload.putFile(File(file!.path));
      imageUrl = await referenceImagesToUpload.getDownloadURL();
    } catch (err) {
      print(err);
    }
  }

  final component = TextEditingController();
  final category = TextEditingController();
  final mrc = TextEditingController();
  final msc = TextEditingController();
  final sc = TextEditingController();
  final dc = TextEditingController();

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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  child: Text(
                    "Add Component",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: component,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Component",
                        hintText: "Enter Component",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Component';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: category,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Category",
                        hintText: "Enter Category",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Category';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: mrc,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Minimum Repair Charge",
                        hintText: "Enter Minimum Repair Charge",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Minimum Repair Charge';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: msc,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Minimum Service Charge",
                        hintText: "Enter Minimum Service Charge",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Minimum Service Charge';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: sc,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Setup Charge",
                        hintText: "Enter Setup Charge",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Setup Charge';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: dc,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Delivery Charge",
                        hintText: "Enter Delivery Charge",
                        labelStyle: TextStyle(fontSize: w * 0.04),
                        hintStyle: TextStyle(fontSize: w * 0.04),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(10))),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Delivery Charge';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Image :",
                        style: TextStyle(
                            fontSize: w * 0.04, fontWeight: FontWeight.w500),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          pickImage();
                        });
                      },
                      child: Container(
                        width: w * 0.6,
                        height: w * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15)),
                        child: file != null
                            ? Image(image: Image.file(File(file!.path)).image)
                            : Icon(
                                Icons.add,
                                size: w * 0.08,
                                color: Colors.grey.shade400,
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    await uploadImage();

                    final addComponent = ComponentModel(
                        category: category.text,
                        image: imageUrl,
                        mrc: mrc.text,
                        msc: msc.text,
                        sc: sc.text,
                        dc: dc.text);

                    await componentController.addComponent(
                        component.text, addComponent);

                    setState(() {
                      component.clear();
                      category.clear();
                      mrc.clear();
                      msc.clear();
                      sc.clear();
                      dc.clear();
                      file == null;
                    });

                    Get.showSnackbar(
                      GetSnackBar(
                        message: "Component added successfully.",
                        duration: Duration(seconds: 2),
                        backgroundColor: Color.fromARGB(255, 35, 35, 35),
                      ),
                    );
                    Navigator.pop(context);
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
    );
  }
}
