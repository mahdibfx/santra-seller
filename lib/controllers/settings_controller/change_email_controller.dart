import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ChangeEmailController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmeEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final form = GlobalKey<FormState>();
  RegExp emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );
}
