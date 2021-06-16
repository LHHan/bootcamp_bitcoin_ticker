import 'package:bootcamp_bitcoin_ticker/services/coin_data.dart';
import 'package:bootcamp_bitcoin_ticker/components/crypto_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bootcamp_bitcoin_ticker/utilities/constants.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coin = CoinData();

  String selectedCurrency = 'USD';
  String rate = '?';
  bool isWaiting = false;
  Map<String, String> coinValue = {};

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> getDropdownItems() {
      return kCurrenciesList.map<DropdownMenuItem<String>>((String currency) {
        return DropdownMenuItem<String>(
          value: currency,
          child: Text(currency),
        );
      }).toList();
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: getDropdownItems(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value.toString();
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> getCupertinoPickerItems() {
      return kCurrenciesList.map<Widget>((String currency) {
        return Text(currency);
      }).toList();
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = kCurrenciesList[selectedIndex];
          getData();
        });
      },
      children: getCupertinoPickerItems(),
    );
  }

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValue = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CryptoCard(
                    rate:
                        isWaiting ? '?' : coinValue[kCryptoList[0]].toString(),
                    selectedCurrency: selectedCurrency,
                    cryto: kCryptoList[0],
                  ),
                  CryptoCard(
                    rate:
                        isWaiting ? '?' : coinValue[kCryptoList[1]].toString(),
                    selectedCurrency: selectedCurrency,
                    cryto: kCryptoList[1],
                  ),
                  CryptoCard(
                    rate:
                        isWaiting ? '?' : coinValue[kCryptoList[2]].toString(),
                    selectedCurrency: selectedCurrency,
                    cryto: kCryptoList[2],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
