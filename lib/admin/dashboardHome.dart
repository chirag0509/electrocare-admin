import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/admin/allAdmins.dart';
import 'package:electrocare_admin/admin/allExecutives.dart';
import 'package:electrocare_admin/admin/allUsers.dart';
import 'package:electrocare_admin/admin/executiveDetails.dart';
import 'package:electrocare_admin/admin/userDetails.dart';
import 'package:electrocare_admin/repository/authentication/auth.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/database/handleExecutive.dart';
import 'package:electrocare_admin/repository/database/handleUser.dart';
import 'package:electrocare_admin/repository/models/adminModel.dart';
import 'package:electrocare_admin/repository/models/executiveModel.dart';
import 'package:electrocare_admin/repository/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/database/handleAdmin.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  final color = ColorController.instance;
  final adminController = Get.put(HandleAdmin());
  final userController = Get.put(HandleUser());
  final executiveController = Get.put(HandleExecutive());

  final String userImage =
      "https://firebasestorage.googleapis.com/v0/b/electrocare0.appspot.com/o/avatar.png?alt=media&token=6b719599-6477-41f8-9bf5-e2e381253e0f";

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: color.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: color.black, size: w * 0.075),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: color.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<AdminModel>(
                  stream: adminController.getAdminDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: w * 0.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data!.name.capitalize}",
                                    style: TextStyle(
                                        fontSize: w * 0.06,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot.data!.email,
                                    style: TextStyle(
                                        fontSize: w * 0.035,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await Auth.instance.logout();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 1,
                                        maximumSize: Size(w * 0.26, h),
                                        backgroundColor: Colors.red,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Logout",
                                          style: TextStyle(
                                              fontSize: w * 0.035,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.logout,
                                          size: w * 0.035,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(6),
                              width: 85,
                              height: 85,
                              decoration: BoxDecoration(
                                color: color.tertiary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      CachedNetworkImage(imageUrl: userImage)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Users",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => AllUsers());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: w * 0.03,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 10),
              child: StreamBuilder<List<UserModel>>(
                  stream: userController.getUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 20, top: 10),
                              child: Container(
                                height: h * 0.1,
                                width: w,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 149, 218, 255),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text("You Don't have any users")),
                              ),
                            )
                          : SizedBox(
                              height: h * 0.24,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 10),
                                      child: InkWell(
                                        onTap: () async {
                                          final user = UserModel(
                                              name: snapshot.data![index].name,
                                              email:
                                                  snapshot.data![index].email,
                                              phone:
                                                  snapshot.data![index].phone,
                                              password: snapshot
                                                  .data![index].password,
                                              image:
                                                  snapshot.data![index].image,
                                              address:
                                                  snapshot.data![index].address,
                                              terms:
                                                  snapshot.data![index].terms);
                                          Get.to(() => UserDetails(user: user));
                                        },
                                        child: Container(
                                          width: w * 0.42,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF3E1F7),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          snapshot.data![index]
                                                              .image),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "${snapshot.data![index].name}"
                                                      .capitalize
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: w * 0.045,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Executives",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => AllExecutives());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: w * 0.03,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 10),
              child: StreamBuilder<List<ExecutiveModel>>(
                  stream: executiveController.getExecutives(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 20, top: 10),
                              child: Container(
                                height: h * 0.1,
                                width: w * 1,
                                decoration: BoxDecoration(
                                  color: Color(0xFF95DAFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child:
                                        Text("You Don't have any executives")),
                              ),
                            )
                          : SizedBox(
                              height: h * 0.24,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 10),
                                      child: InkWell(
                                        onTap: () async {
                                          final user = ExecutiveModel(
                                              name: snapshot.data![index].name,
                                              email:
                                                  snapshot.data![index].email,
                                              dob: snapshot.data![index].dob,
                                              address:
                                                  snapshot.data![index].address,
                                              jobType:
                                                  snapshot.data![index].jobType,
                                              password: snapshot
                                                  .data![index].password);
                                          Get.to(() =>
                                              ExecutiveDetails(user: user));
                                        },
                                        child: Container(
                                          width: w * 0.42,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFCAE9F1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          userImage),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "${snapshot.data![index].name}"
                                                      .capitalize
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: w * 0.045,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Admins",
                    style: TextStyle(
                        fontSize: w * 0.06, fontWeight: FontWeight.w500),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => AllAdmins());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 0.5, color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: w * 0.03,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 10),
              child: StreamBuilder<List>(
                  stream: adminController.getAdmins(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.length == 0
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, right: 20, top: 10),
                              child: Container(
                                height: h * 0.1,
                                width: w * 1,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 149, 218, 255),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                    child: Text("You Don't have any admins")),
                              ),
                            )
                          : SizedBox(
                              height: h * 0.24,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 10),
                                      child: InkWell(
                                        onTap: () async {},
                                        child: Container(
                                          width: w * 0.42,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD1D4FA),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                SizedBox(height: 10),
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      CachedNetworkImageProvider(
                                                          userImage),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  "${snapshot.data![index]["name"]}"
                                                      .capitalize
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: w * 0.045,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
