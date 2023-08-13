import 'package:cached_network_image/cached_network_image.dart';
import 'package:electrocare_admin/admin/components.dart';
import 'package:electrocare_admin/admin/dashboardHome.dart';
import 'package:electrocare_admin/admin/eVerify.dart';
import 'package:electrocare_admin/admin/offers.dart';
import 'package:electrocare_admin/admin/services.dart';
import 'package:electrocare_admin/admin/support.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  PageController pageController = new PageController(initialPage: 0);
  final color = ColorController.instance;
  int _currentIndex = 0;

  final _bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_outlined,
      ),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.category_outlined,
      ),
      label: 'Components',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.request_page_outlined,
      ),
      label: 'EVerify',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_repair_service_outlined,
      ),
      label: 'Services',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.local_offer_outlined,
      ),
      label: 'Offers',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.chat_outlined,
      ),
      label: 'Support',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      backgroundColor: color.white,
      body: PageView(
        controller: pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        children: [
          DashboardHome(),
          Components(),
          EVerify(),
          Services(),
          Offers(),
          Support(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color(0xFFa9a9a9),
        backgroundColor: color.secondary,
        items: _bottomNavigationBarItems,
        iconSize: w * 0.06,
        currentIndex: _currentIndex,
        onTap: (index) {
          pageController.animateToPage(index,
              duration: Duration(microseconds: 300), curve: Curves.ease);
        },
        type: BottomNavigationBarType.fixed,
      ),
    ));
  }
}
