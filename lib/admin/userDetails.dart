import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/repository/database/handleUser.dart';
import 'package:electrocare_admin/repository/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;
  const UserDetails({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final userController = Get.put(HandleUser());
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: CircleAvatar(
                radius: 70,
                backgroundImage: CachedNetworkImageProvider(widget.user.image),
              )),
              SizedBox(height: 10),
              Center(
                  child: Text("${widget.user.name.capitalize}",
                      style: TextStyle(
                          fontSize: w * 0.06, fontWeight: FontWeight.w500))),
              SizedBox(height: 30),
              Text("Email : ${widget.user.email}",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Text("Phone : +91 ${widget.user.phone}",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Text("Address : ${widget.user.address}",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFFCAE9F1),
                        borderRadius: BorderRadius.circular(10)),
                    child: StreamBuilder(
                      stream: userController.pendingServices(widget.user.phone),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Services pending",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("${snapshot.data!.length}",
                                  style: TextStyle(
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.w500)),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Services pending",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("Loading..."),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFD1D4FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder(
                      stream:
                          userController.inProcessServices(widget.user.phone),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Services in process",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("${snapshot.data!.length}",
                                  style: TextStyle(
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.w500)),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Services in process",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("Loading..."),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFFF3E1F7),
                        borderRadius: BorderRadius.circular(10)),
                    child: StreamBuilder(
                      stream:
                          userController.completedServices(widget.user.phone),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Services completed",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("${snapshot.data!.length}",
                                  style: TextStyle(
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.w500)),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Services completed",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("Loading..."),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color(0xFFF3E1F7),
                        borderRadius: BorderRadius.circular(10)),
                    child: StreamBuilder(
                      stream: userController.feedbacks(widget.user.email),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Feedbacks given",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("${snapshot.data!.length}",
                                  style: TextStyle(
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.w500)),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Feedbacks given",
                                style: TextStyle(fontSize: w * 0.045),
                              ),
                              Text("Loading..."),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
