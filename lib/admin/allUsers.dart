import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/admin/userDetails.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/database/handleUser.dart';
import 'package:electrocare_admin/repository/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final userController = Get.put(HandleUser());
  final color = ColorController.instance;

  TextEditingController _searchController = TextEditingController();
  String _searchValue = '';
  FocusNode _focusNode = FocusNode();
  List<String> selectedUsers = [];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: w * 0.06,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: _searchController,
                style: TextStyle(fontSize: w * 0.045),
                decoration: InputDecoration(
                    hintText: "Search Users",
                    hintStyle: TextStyle(fontSize: w * 0.045),
                    filled: true,
                    fillColor: Color(0xFFf1f1f1),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50))),
                onChanged: (value) {
                  setState(() {
                    _searchValue = value;
                  });
                },
                focusNode: _focusNode,
                onFieldSubmitted: (value) {
                  _focusNode.unfocus();
                },
              ),
            ),
            StreamBuilder<List<UserModel>>(
                stream: userController.getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List filteredData = snapshot.data!
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(_searchValue.toLowerCase()))
                        .where((element) =>
                            selectedUsers.isEmpty ||
                            selectedUsers.contains(element.name))
                        .toList();

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
                                  child: Text("You Don't have any users")),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12),
                                shrinkWrap: true,
                                itemCount: filteredData.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      final user = UserModel(
                                          name: snapshot.data![index].name,
                                          email: snapshot.data![index].email,
                                          phone: snapshot.data![index].phone,
                                          password:
                                              snapshot.data![index].password,
                                          image: snapshot.data![index].image,
                                          address:
                                              snapshot.data![index].address,
                                          terms: snapshot.data![index].terms);
                                      Get.to(() => UserDetails(user: user));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFF3E1F7),
                                        borderRadius: BorderRadius.circular(10),
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
                                                      filteredData[index]
                                                          .image),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "${filteredData[index].name}"
                                                  .capitalize
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: w * 0.045,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    ));
  }
}
