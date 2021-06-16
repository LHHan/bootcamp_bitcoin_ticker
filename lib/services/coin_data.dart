import 'package:bootcamp_bitcoin_ticker/services/networking.dart';
import 'package:bootcamp_bitcoin_ticker/utilities/constants.dart';

class CoinData {
  Future getCoinData(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in kCryptoList) {
      NetworkHelper networkHelper = NetworkHelper(
          url: Uri.https(
        kCoinApiUrlAuthority,
        '$kCoinApiUrlUnencodedPath$crypto/$currency',
        {
          'apikey': kCoinApiKey,
        },
      ));

      var coinData = await networkHelper.getCoinApi();

      cryptoPrices[crypto] = coinData['rate'].toStringAsFixed(2);
    }

    return cryptoPrices;
  }
}
