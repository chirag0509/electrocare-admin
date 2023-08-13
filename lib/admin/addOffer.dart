import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/database/handleOffer.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddOffer extends StatefulWidget {
  const AddOffer({super.key});

  @override
  State<AddOffer> createState() => _AddOfferState();
}

class _AddOfferState extends State<AddOffer> {
  final color = ColorController.instance;
  final offerController = Get.put(HandleOffer());

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
    Reference referenceDirImages = referenceRoot.child("offers");
    Reference referenceImagesToUpload =
        referenceDirImages.child(uniqueFileName);
    try {
      await referenceImagesToUpload.putFile(File(file!.path));
      imageUrl = await referenceImagesToUpload.getDownloadURL();
    } catch (err) {
      print(err);
    }
  }

  final valid = TextEditingController();
  final offer = TextEditingController();

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
                    "Add Offer",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: valid,
                    style: TextStyle(fontSize: w * 0.04),
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now().add(Duration(days: 90)),
                      );

                      if (selectedDate != null) {
                        // Update the selected date in the text field
                        valid.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                        labelText: "Validity",
                        hintText: "DD/MM/YYYY",
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: offer,
                    style: TextStyle(fontSize: w * 0.04),
                    decoration: InputDecoration(
                        alignLabelWithHint: true,
                        labelText: "Offer",
                        hintText: "Enter Offer",
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

                    DateTime validDate =
                        DateFormat('dd/MM/yyyy').parse(valid.text);
                    Timestamp validTimestamp = Timestamp.fromDate(validDate);

                    await FirebaseFirestore.instance.collection("offers").add({
                      "image": imageUrl,
                      "offer": offer.text,
                      "valid": validTimestamp,
                    });

                    setState(() {
                      valid.clear();
                      offer.clear();

                      file == null;
                    });

                    Get.showSnackbar(
                      GetSnackBar(
                        message: "Offer added successfully.",
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
