import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/repository/database/handleServices.dart';
import 'package:electrocare_admin/repository/models/serviceModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  final serviceController = Get.put(HandleServices());

  Map<int, String> selectedExecutives = {};

  Stream<List<DropdownMenuItem<String>>> _getAvailableExecutivesStream(
      String appliance) async* {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('executives').get();

    List<DropdownMenuItem<String>> availableExecutives = [];

    for (var i in querySnapshot.docs) {
      List<dynamic> jobType = i.data()['jobType'];

      if (jobType.contains(appliance)) {
        String executiveEmail = i.data()['email'];

        availableExecutives.add(
          DropdownMenuItem<String>(
            value: executiveEmail,
            child: Text(executiveEmail),
          ),
        );
      }
    }

    print(availableExecutives);
    yield availableExecutives;
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
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return index == 0
                      ? StreamBuilder(
                          stream: serviceController.pendingServices(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFCAE9F1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        "Services pending",
                                        style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              "${snapshot.data!.length}",
                                              style: TextStyle(
                                                  fontSize: w * 0.08,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : StreamBuilder(
                          stream: serviceController.inProcessServices(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD1D4FA),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        "Services in process",
                                        style: TextStyle(
                                            fontSize: w * 0.045,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              "${snapshot.data!.length}",
                                              style: TextStyle(
                                                  fontSize: w * 0.08,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                },
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: serviceController.completedServices(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF3E1F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "Completed Services",
                              style: TextStyle(
                                  fontSize: w * 0.045,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              "${snapshot.data!.length}",
                              style: TextStyle(
                                  fontSize: w * 0.08,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: StreamBuilder<List<ServiceModel>>(
                  stream: serviceController.notAssignedServices(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: h * 0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 215, 188),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: snapshot.data!.length == 0
                                ? Center(
                                    child: Text(
                                        "There are no services at this moment."),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxWidth: w * 0.6),
                                                    child: Text(
                                                      snapshot.data![index]
                                                          .client.capitalize
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: w * 0.04,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    w * 0.3),
                                                        child: Text(
                                                          snapshot.data![index]
                                                                  .appliance +
                                                              "  :  ",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  w * 0.03,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    w * 0.3),
                                                        child: Text(
                                                          snapshot.data![index]
                                                              .problem,
                                                          style: TextStyle(
                                                              fontSize:
                                                                  w * 0.03,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              StreamBuilder<
                                                  List<
                                                      DropdownMenuItem<
                                                          String>>>(
                                                stream:
                                                    _getAvailableExecutivesStream(
                                                        snapshot.data![index]
                                                            .appliance),
                                                builder: (context, dropSnap) {
                                                  if (dropSnap.hasData) {
                                                    List<
                                                            DropdownMenuItem<
                                                                String>> items =
                                                        dropSnap.data!;

                                                    return ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth:
                                                                  w * 0.35),
                                                      child: DropdownButton<
                                                          String>(
                                                        isExpanded: true,
                                                        menuMaxHeight: 150,
                                                        value:
                                                            selectedExecutives[
                                                                index],
                                                        hint: Text(
                                                          'Select an executive',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  w * 0.03),
                                                        ),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            selectedExecutives[
                                                                    index] =
                                                                newValue!;
                                                          });
                                                          if (selectedExecutives[
                                                                      index] !=
                                                                  "" &&
                                                              selectedExecutives[
                                                                      index] !=
                                                                  null) {
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      "Confirm executive?"),
                                                                  content: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                                                          child: Text("Close")),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            final executiveDoc =
                                                                                await FirebaseFirestore.instance.collection("executives").doc(selectedExecutives[index]).get();
                                                                            String
                                                                                executiveName =
                                                                                executiveDoc.get("name");
                                                                            final service = ServiceModel(
                                                                                client: snapshot.data![index].client,
                                                                                clientPhone: snapshot.data![index].clientPhone,
                                                                                clientAddress: snapshot.data![index].clientAddress,
                                                                                executive: executiveName,
                                                                                executiveID: selectedExecutives[index].toString(),
                                                                                appliance: snapshot.data![index].appliance,
                                                                                model: snapshot.data![index].model,
                                                                                problem: snapshot.data![index].problem,
                                                                                paymentStatus: snapshot.data![index].paymentStatus,
                                                                                serviceStatus: snapshot.data![index].serviceStatus,
                                                                                repairCharge: snapshot.data![index].repairCharge,
                                                                                serviceCharge: snapshot.data![index].serviceCharge,
                                                                                setupCharge: snapshot.data![index].setupCharge,
                                                                                deliveryCharge: snapshot.data![index].deliveryCharge,
                                                                                time: Timestamp.now());
                                                                            await serviceController.updateService(snapshot.data![index].id!,
                                                                                service);
                                                                            setState(() {
                                                                              selectedExecutives.clear();
                                                                            });
                                                                            Navigator.pop(context);
                                                                            Get.showSnackbar(
                                                                              GetSnackBar(
                                                                                message: "Executive assigned.",
                                                                                duration: Duration(seconds: 2),
                                                                                backgroundColor: Color.fromARGB(255, 35, 35, 35),
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text("Confirm")),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        },
                                                        items: items,
                                                      ),
                                                    );
                                                  } else {
                                                    return SizedBox();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Divider(
                                              thickness: 1,
                                              color: Color.fromARGB(
                                                  255, 255, 137, 58),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
