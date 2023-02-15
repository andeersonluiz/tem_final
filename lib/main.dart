import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay, rootBundle;
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/injection.dart';
import 'package:tem_final/src/presenter/pages/home_view_page.dart';

import 'src/core/utils/routes_names.dart';
import 'src/data/models/tv_show_and_movie_model.dart';
import 'src/presenter/routes/router.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: "https://imqmttavuchgrverzvee.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImltcW10dGF2dWNoZ3J2ZXJ6dmVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzYyNDY2ODgsImV4cCI6MTk5MTgyMjY4OH0.hl6Rw7phI4wwaeEEk4LJB3SMnEOn1XcjTBnu-PQQ4ko",
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  /* var file = await rootBundle.loadString('assets/dataUpdated.json');
  var result = jsonDecode(file);
  for (var item in result) {
    try {
      await supabase.from(kDocumentTvShowAndMovies).insert(item);
    } catch (e) {
      print("${item["id"]} repetido");
    }
  }*/
/*
  var x = await supabase
      .from(kDocumentTvShowAndMovies)
      .select()
      .eq("id", "140225063");

  for (GenreType genre in GenreType.values) {
    var genreArray = [genre.string];
    var queryDocumentData = (await supabase
        .from("tvShowAndMovies")
        .select()
        .containedBy("genres", ["Drama", "História"]));

    print(queryDocumentData.runtimeType);
    print(queryDocumentData.length);
    print(queryDocumentData.first);
    List<Map<String, dynamic>> maps = queryDocumentData
        .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
        .toList();
    for (var item in maps) {
      print(item["genres"]);
    }
    break;
  }
*/
  print("foise");
  await initializeDependencies();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.home,
    getPages: MyRouter.routes,
  ));
}
