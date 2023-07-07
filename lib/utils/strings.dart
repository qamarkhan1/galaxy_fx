import 'dart:math';
import 'dart:convert';

import 'colors.dart';

const users = "users";
const theme = 'theme';
const settings = 'settings';
const lanaguageCodes = 'lanaguageCodes';

const pinCode = 'pinCode';
const activePinCode = 'activePinCode';

const more = 'more';

const email = "email";
const password = "password";
const name = "name";
const refBy = "refBy";

const status = 'status';
const message = 'message';
const defaultError = "Something went wrong";
const userConfig = "user_config";

const userNotify = "user_notify";

const authConfig = "auth_config";
const lockPin = "lockPin";

const rateKey = 'rates';
const currenciesKey = 'currencies';

const ip = 'ip';
const location = 'location';
const country = 'country';
const deviceName = 'deviceName';
const platform = 'platform';
const mobile = 'mobile';

const chars = "abcdefghijklmnopqrstuvwxyz0123456789";

const emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

String randomString(int strlen) {
  Random rnd = Random(DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

extension StringExtension on String? {
  String capitalize() {
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }
}

extension PrettyJson on Map<String, dynamic> {
  String toPrettyString() {
    var encoder = const JsonEncoder.withIndent("     ");
    return encoder.convert(this);
  }
}

const english = "english";
const french = "french";
const japanese = "japanese";
const chinese = "chinese";
const hindi = "hindi";
const russian = "russian";
const korean = "korean";
const belgium = "belgium";
const german = "german";
const spanish = "spanish";
const portuguese = "portuguese";
const indonesian = "indonesian";
const arabic = "arabic";

const List<String> languaeCodes = [
  'ar',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'id',
  'ja',
  'ko',
  'nl',
  'pt',
  'ru',
  'zh',
];

const system = 'system';
const light = 'light';
const dark = 'dark';

const List themeModes = [
  system,
  light,
  dark,
];

const completed = 'completed';
const pending = 'pending';
const failed = 'failed';
const success = 'success';

const List payStatus = [
  pending,
  completed,
  failed,
];

List payStatusColor = [
  amber,
  green,
  red,
];

const active = 'active';
const inactive = 'inactive';

const List refStatus = [
  active,
  inactive,
];

const deposit = 'deposit';
const withdrawal = 'withdrawal';

const bitcoin = 'bitcoin';
const ethereum = 'ethereum';
const tether = 'tether';
const litecoin = 'litecoin';
const dogecoin = 'dogecoin';
const bnb = 'bnb';
const tron = 'tron';

const List<String> cryptoList = [
  bitcoin,
  ethereum,
  tether,
  litecoin,
  dogecoin,
  bnb,
  tron,
];

const defaultCurrency = 'USD';
const defaultCurrencySymbol = '\$';
const defaultRate = 1.0;

const paypal = 'paypal';
const upi = 'upi';
const paystack = 'paystack';
const flutterwave = 'flutterwave';
const bank = 'bank';
const cryptocurrency = 'cryptocurrency';
const appPay = 'appPay';
const applePay = 'applePay';
const googlePay = 'googlePay';
const stripe = 'stripe';
const mobileMoneyAuto = 'mobileMoney(auto)';
const mobileMoneyManual = 'mobileMoney(manual)';

const List depositMethods = [
  // appPay,
  mobileMoneyAuto, mobileMoneyManual,
  bank,
  cryptocurrency,
  paystack,
  stripe,
];

const List withdrawalMethods = [
  paypal,
  bank,
  cryptocurrency,
];

const erc20 = 'erc20';
const List erc20List = [
  bnb,
  tether,
  ethereum,
];
const List languageList = [
  english,
];

const paystackCurrencies = [
  'ngn',
  'ghs',
  'zar',
  'usd',
];

const topics = [
  'general',
  'signals',
  'classes',
  'subscriptions',
  'investments',
];

const systemTheme = "System Theme";
const lightTheme = "Light Theme";
const darkTheme = "Dark Theme";

const face = "Face";
const touchId = "TouchId";

const activeCurrency = 'activeCurrency';
const activeRate = 'activeRate';
