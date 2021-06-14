import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';
import 'price_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String selectedCurrency = 'AUD';
  String rate = '?';
  Map<String, String> cryptoCurrncyPrice = {};

  void getRate(String selectedCurrncy) async {
    Map<String, String> cryptoPrice = {};
    try {
      for (var crypto in cryptoList) {
        cryptoPrice[crypto] = await coinData.getExchangeRate(
            currncy: selectedCurrncy, cryptoName: crypto);
      }
      setState(() {
        cryptoCurrncyPrice = cryptoPrice;
      });
    } catch (e) {
      print(e);
    }
  }

  // drop down for Android
  DropdownButton<String> androidDropDown() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: [
        for (var currency in currenciesList)
          DropdownMenuItem(
            child: Text(currency),
            value: currency,
          ),
      ],
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getRate(selectedCurrency);
        });
      },
    );
  }

  // drop down for IOS
  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(
        Text(
          currency,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    return CupertinoPicker(
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = pickerItems[selectedIndex].data!;
        getRate(selectedCurrency);
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getRate(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var crypto in cryptoList)
                  PriceCard(
                    rate: cryptoCurrncyPrice[crypto] ?? '?',
                    selectedCurrency: selectedCurrency,
                    selectedCrypto: crypto,
                  ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
