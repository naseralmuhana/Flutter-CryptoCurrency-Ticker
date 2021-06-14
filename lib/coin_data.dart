import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

// const String apiKey = '54185A03-8C2C-4413-9E10-92F2C7BF687B';
// const String apiKey = '1C27B3BF-D5BF-4D30-ADF2-20A4CCDD0BE5';
const String apiKey = 'AA0D175C-FAF4-4267-81B2-95C2CB65DBA2';
const String coinApiUrl = 'https://rest.coinapi.io/v1/exchangerate';

class CoinData {
  Future<String> getExchangeRate(
      {required String currncy, required String cryptoName}) async {
    final response = await http.get(
      Uri.parse('$coinApiUrl/$cryptoName/$currncy?apikey=$apiKey'),
    );
    if (response.statusCode == 200) {
      var data = convert.jsonDecode(response.body);
      var lastPrice = data['rate'];
      return lastPrice.toStringAsFixed(2);
    } else {
      print(response.statusCode);
      throw 'Problem with the get request';
    }
  }
}
