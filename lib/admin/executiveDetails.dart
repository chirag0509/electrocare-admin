import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/repository/database/handleExecutive.dart';
import 'package:electrocare_admin/repository/database/handleUser.dart';
import 'package:electrocare_admin/repository/models/executiveModel.dart';
import 'package:electrocare_admin/repository/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExecutiveDetails extends StatefulWidget {
  final ExecutiveModel user;
  const ExecutiveDetails({Key? key, required this.user}) : super(key: key);

  @override
  State<ExecutiveDetails> createState() => _ExecutiveDetailsState();
}

class _ExecutiveDetailsState extends State<ExecutiveDetails> {
  final userController = Get.put(HandleExecutive());
  final String userImage =
      "https://firebasestorage.googleapis.com/v0/b/electrocare0.appspot.com/o/avatar.png?alt=media&token=6b719599-6477-41f8-9bf5-e2e381253e0f";
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
                backgroundImage: CachedNetworkImageProvider(userImage),
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
              Text("Address : ${widget.user.address}",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Text("Job Type :",
                  style: TextStyle(
                      fontSize: w * 0.04, fontWeight: FontWeight.w500)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: widget.user.jobType.map((value) {
                  return Chip(
                    label: Text(value),
                  );
                }).toList(),
              ),
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
                      stream: userController.pendingServices(widget.user.email),
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
                          userController.inProcessServices(widget.user.email),
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
                          userController.completedServices(widget.user.email),
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
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
