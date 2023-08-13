import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  static FormController get instance => Get.find();

  final name = TextEditingController();
  final email = TextEditingController();
  final dob = TextEditingController();
  final password = TextEditingController();
  final confirmNewPassword = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();
  final address = TextEditingController();
  final repairCharge = TextEditingController();
  final serviceCharge = TextEditingController();
  final setupCharge = TextEditingController();
  final deliveryCharge = TextEditingController();

  final emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final dobRegex = r'^\d{2}/\d{2}/\d{4}$';
}
