import 'dart:convert';

import 'package:flutter/material.dart';
import './screen/login.dart';
import './screen/HomePage.dart';
import './screen/HomePage1.dart';
import './screen/nyoba.dart';
import './screen/registrasi.dart';
import './screen/Produk_detail.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/registrasi': (context) => Registrasi(),
        '/login': (context) => Login(),
     
     

      },
      home: Login()
    );
  }
}








