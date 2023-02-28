import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChangePasswordController extends GetxController {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final form = GlobalKey<FormState>();
}
