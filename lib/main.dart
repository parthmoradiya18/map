import 'package:flutter/material.dart';
import 'package:map/homepage.dart';
//import 'package:map/mapspage.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => const HomePage(),
       //"google_map_page": (context) => const GoogleMapPage(),
      },
    ),
  );
}
