import 'package:flutter/foundation.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:get/get_connect/connect.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BaseApis {
  currencyRatesGet();
}

class CurrencyApi extends GetConnect {
  final _box = Hive.box(settings);

  currencyRatesGet() async {
    Map rates = {};
    List currenciesList = [];
    try {
      Response response = await get(
        'https://api.exchangerate.host/latest?base=usd',
      );

      var body = response.body;

      if (body['success']) {
        Map allRates = body['rates'];

        rates = allRates;
        List currencies = allRates.keys.toList();
        currenciesList = currencies;
      } else {
        rates = {
          'USD': defaultRate,
        };
        currenciesList = ['USD'];
      }
      _box.put(rateKey, rates);
      _box.put(currenciesKey, currenciesList);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
