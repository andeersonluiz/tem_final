import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/home_view_page.dart';
import 'package:tem_final/src/presenter/routes/router.dart';

import 'injection_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await mockInitializeDependencies();
  runApp(GetMaterialApp(
    initialRoute: Routes.home,
    getPages: MyRouter.routes,
  ));
}
