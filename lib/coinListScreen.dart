import 'package:digitalcurrency/data/constant/constants.dart';
import 'package:digitalcurrency/model/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptoList});

  List<Crypto>? cryptoList;

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? cryptoList;
  bool isSearchLoadingVisible = false;

  @override
  void initState() {
    cryptoList = widget.cryptoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: blackColor,
        title: const Text(
          'کریپتو بازار',
          style: TextStyle(fontFamily: 'mr'),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: blackColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                onChanged: (value) {
                  _filterList(value);
                },
                decoration: InputDecoration(
                    hintText: 'اسم رمز ارز را سرچ کنید ',
                    hintStyle: TextStyle(fontFamily: 'mr', color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    fillColor: greenColor,
                    filled: true),
              ),
            ),
          ),
          Visibility(
            visible: isSearchLoadingVisible,
              child: Text(
            'درحال آپدیت رمز ارزها',
            style: TextStyle(color: greenColor, fontFamily: 'mr'),
          )),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: greenColor,
              color: blackColor,
              onRefresh: () async {
                List<Crypto> fereshData = await _getData();
                setState(() {
                  cryptoList = fereshData;
                });
              },
              child: ListView.builder(
                itemCount: cryptoList!.length,
                itemBuilder: (context, index) {
                  return _getListTileItem(cryptoList![index]);
                },
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
        title: Text(
          crypto.name,
          style: const TextStyle(color: greenColor),
        ),
        subtitle: Text(
          crypto.symbol,
          style: const TextStyle(color: greyColor),
        ),
        leading: SizedBox(
          width: 30,
          child: Center(
            child: Text(
              crypto.rank.toString(),
              style: const TextStyle(color: greyColor),
            ),
          ),
        ),
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    crypto.priceUsd.toStringAsFixed(2),
                    style: const TextStyle(color: greyColor, fontSize: 18),
                  ),
                  Text(
                    crypto.changePercent24Hr.toStringAsFixed(2),
                    style: TextStyle(
                        color: _getColorChangeText(crypto.changePercent24Hr)),
                  ),
                ],
              ),
              SizedBox(
                  width: 50,
                  child: Center(
                      child: _getIconChangePercent(crypto.changePercent24Hr))),
            ],
          ),
        ));
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? const Icon(
            Icons.trending_down,
            size: 24,
            color: redColor,
          )
        : const Icon(
            Icons.trending_up,
            size: 24,
            color: greenColor,
          );
  }

  Color _getColorChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> _getData() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<Crypto> cryptoList = response.data['data']
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    return cryptoList;
  }

  Future<void> _filterList(String enterdKeyword) async {
    List<Crypto> cryptoResultList = [];

    if (enterdKeyword.isEmpty) {
      setState(() {
        isSearchLoadingVisible = true;

      });
      var result = await _getData();
      setState(() {
        cryptoList = result;
        isSearchLoadingVisible = false;

      });
      return;
    }

    cryptoResultList = cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enterdKeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptoList = cryptoResultList;
    });
  }
}
