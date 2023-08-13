import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/admin/addComponent.dart';
import 'package:electrocare_admin/admin/addOffer.dart';
import 'package:electrocare_admin/repository/database/handleComponent.dart';
import 'package:electrocare_admin/repository/database/handleOffer.dart';
import 'package:electrocare_admin/repository/models/componentModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class Offers extends StatefulWidget {
  const Offers({super.key});

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  final offerController = Get.put(HandleOffer());

  

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
                        Get.to(() => AddOffer());
                      },
                      child: Text(
                        "+ Add Offer",
                        style: TextStyle(
                          fontSize: w * 0.04,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: offerController.getOffers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Color> colors = [
                      Color(0xFFCAE9F1),
                      Color(0xFFD1D4FA),
                      Color(0xFFF3E1F7)
                    ];
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        Color color = colors[index % colors.length];
                        DateTime validDate =
                            snapshot.data![index]['valid'].toDate();
                        String formattedDate =
                            DateFormat.MMMM().format(validDate) +
                                ' ' +
                                DateFormat.d().format(validDate);
                        return Container(
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 20),
                                child: Text("Valid until $formattedDate"),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 50, top: 10),
                                child: Text(
                                  snapshot.data![index]['offer'],
                                  style: TextStyle(
                                    fontSize: w * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data![index]['image'],
                                      width: w * 0.23,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox(
                      height: h * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 20),
                              child: Container(
                                width: w * 0.42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.5),
                                      Colors.white.withOpacity(0.3),
                                      Colors.white.withOpacity(0.5),
                                    ],
                                    stops: const [0.4, 0.5, 0.6],
                                  ),
                                ),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  direction: ShimmerDirection.ltr,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
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
