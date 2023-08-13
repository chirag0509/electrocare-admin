import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/admin/addComponent.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
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
              StreamBuilder<List>(
                stream: FirebaseFirestore.instance
                    .collection("support")
                    .orderBy("time")
                    .snapshots()
                    .map((event) => event.docs.toList()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return data.length == 0
                        ? Center(
                            child: Text("You do not have any messages."),
                          )
                        : ListView.builder(
                            itemCount: data.length,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${data[index]['name']}"
                                                  .capitalize
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: w * 0.04,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${data[index]['email']}",
                                              style: TextStyle(
                                                  fontSize: w * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Subject : ${data[index]['subject']}",
                                              style: TextStyle(
                                                  fontSize: w * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Message : ${data[index]['message']}",
                                              style: TextStyle(
                                                  fontSize: w * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              await FirebaseFirestore.instance
                                                  .collection("support")
                                                  .doc(data[index].id)
                                                  .delete();
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: w * 0.045,
                                            )),
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
