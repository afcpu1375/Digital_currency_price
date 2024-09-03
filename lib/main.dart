import 'package:digitalcurrency/HomeScreen.dart';
import 'package:digitalcurrency/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'coinListScreen.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
