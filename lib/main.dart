import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electrocare_admin/admin/allAdmins.dart';
import 'package:electrocare_admin/admin/allExecutives.dart';
import 'package:electrocare_admin/admin/allUsers.dart';
import 'package:electrocare_admin/admin/components.dart';
import 'package:electrocare_admin/admin/eVerify.dart';
import 'package:electrocare_admin/admin/offers.dart';
import 'package:electrocare_admin/admin/support.dart';
import 'package:electrocare_admin/repository/authentication/auth.dart';
import 'package:electrocare_admin/repository/controller/colorController.dart';
import 'package:electrocare_admin/repository/controller/formController.dart';
import 'package:electrocare_admin/repository/database/firebase_options.dart';
import 'package:electrocare_admin/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin/dashboard.dart';
import 'admin/dashboardHome.dart';
import 'admin/services.dart';
import 'forms/login.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
    Get.put(Auth());
    Get.put(FormController());
    Get.put(ColorController());
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final color = ColorController.instance;

  void initState() {
    checkOffer();
    super.initState();
  }

  void checkOffer() async {
    final offerDocs =
        await FirebaseFirestore.instance.collection("offers").get();
    final currentTimestamp = Timestamp.now();
    if (offerDocs.docs.isNotEmpty) {
      for (var i in offerDocs.docs) {
        Timestamp offerTimestamp = i["valid"];
        if (offerTimestamp.compareTo(currentTimestamp) < 0) {
          deleteOffer(i.id, i["image"]);
        }
      }
    }
  }

  Future<void> deleteOffer(String offerId, String imageUrl) async {
    try {
      // Delete from Firestore collection
      await FirebaseFirestore.instance
          .collection('offers')
          .doc(offerId)
          .delete();

      // Delete from Firebase Storage
      if (imageUrl.isNotEmpty) {
        final Reference storageRef =
            FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Show a success message or perform any other necessary actions
    } catch (error) {
      // Handle errors
      print("Error deleting Offer: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(
        color.primary.value,
        <int, Color>{
          50: color.primary.withOpacity(0.1),
          100: color.primary.withOpacity(0.2),
          200: color.primary.withOpacity(0.3),
          300: color.primary.withOpacity(0.4),
          400: color.primary.withOpacity(0.5),
          500: color.primary.withOpacity(0.6),
          600: color.primary.withOpacity(0.7),
          700: color.primary.withOpacity(0.8),
          800: color.primary.withOpacity(0.9),
          900: color.primary.withOpacity(1),
        },
      )),
      getPages: [
        GetPage(name: MyRoutes.home, page: () => Home()),
        GetPage(name: MyRoutes.login, page: () => Login()),
        GetPage(name: UserRoutes.dashboard, page: () => Dashboard()),
        GetPage(name: UserRoutes.dashboardHome, page: () => DashboardHome()),
        GetPage(name: UserRoutes.components, page: () => Components()),
        GetPage(name: UserRoutes.eVerify, page: () => EVerify()),
        GetPage(name: UserRoutes.offers, page: () => Offers()),
        GetPage(name: UserRoutes.support, page: () => Support()),
        GetPage(name: UserRoutes.services, page: () => Services()),
        GetPage(name: UserRoutes.allUsers, page: () => AllUsers()),
        GetPage(name: UserRoutes.allExecutives, page: () => AllExecutives()),
        GetPage(name: UserRoutes.allAdmins, page: () => AllAdmins()),
      ],
    );
  }
}
