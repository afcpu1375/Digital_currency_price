import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:digitalcurrency/model/crypto.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'coinListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image(image: AssetImage('assets/images/logo.png')),
          SpinKitFadingCube(
            color: Colors.grey[900],
            size: 30.0,
          ),
        ],)
      ),
    );
  }

  Future<void> getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return CoinListScreen(cryptoList: cryptoList,);
      },
    ));
  }
}
