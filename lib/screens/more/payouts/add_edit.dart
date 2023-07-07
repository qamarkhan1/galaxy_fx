import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/controllers/payout_ctrl.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_text_field.dart';
import 'package:get/get.dart';

import '../../../utils/config.dart';
import '../../../utils/strings.dart';

class PayoutsAddEdit extends StatelessWidget {
  const PayoutsAddEdit({Key? key, this.data}) : super(key: key);
  final Map? data;
  @override
  Widget build(BuildContext context) {
    TextEditingController paypalEmailCtrl = TextEditingController()
      ..text = data == null ? "" : data!['paypal_email'] ?? "";
    TextEditingController currencyCtrl = TextEditingController()
      ..text = data == null ? "" : data!['currency'] ?? "";
    TextEditingController countryIssuedCtrl = TextEditingController()
      ..text = data == null ? "" : data!['country_issued'] ?? "";
    TextEditingController accountNameCtrl = TextEditingController()
      ..text = data == null ? "" : data!['account_name'] ?? "";
    TextEditingController bankNameCtrl = TextEditingController()
      ..text = data == null ? "" : data!['bank_name'] ?? "";
    TextEditingController accountNumCtrl = TextEditingController()
      ..text = data == null ? "" : data!['account_number'] ?? "";
    TextEditingController bankSwiftCtrl = TextEditingController()
      ..text = data == null ? "" : data!['swift_code'] ?? "";
    TextEditingController bankSortCtrl = TextEditingController()
      ..text = data == null ? "" : data!['sort_code'] ?? "";
    TextEditingController ibanCtrl = TextEditingController()
      ..text = data == null ? "" : data!['iban'] ?? "";
    TextEditingController cryptocurrencyCtrl = TextEditingController()
      ..text = data == null ? "" : data!['cryptocurrency'] ?? "";
    TextEditingController walletAddCtrl = TextEditingController()
      ..text = data == null ? "" : data!['wallet_address'] ?? "";
    AllRepos allRepos = AllRepos();

    Get.find<PayoutController>().activePaymethod.value =
        data == null ? paypal : data!['payment_method'];
    return CustScaffold(
      title: '',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data == null
                        ? 'Add New Payout Method'
                        : 'Update Payout Method',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text('Paypal Email'),
                  CustTextField(controller: paypalEmailCtrl),
                  const SizedBox(height: 20),
                  const Text('Currency'),
                  CustTextField(controller: currencyCtrl),
                  const SizedBox(height: 20),
                  const Text('Country Issued'),
                  CustTextField(controller: countryIssuedCtrl),
                  const SizedBox(height: 20),
                  const Text('Account Name'),
                  CustTextField(controller: accountNameCtrl),
                  const SizedBox(height: 20),
                  const Text('Bank Name'),
                  CustTextField(controller: bankNameCtrl),
                  const SizedBox(height: 20),
                  const Text('Account Number'),
                  CustTextField(controller: accountNumCtrl),
                  const SizedBox(height: 20),
                  const Text('Bank Swift Code'),
                  CustTextField(controller: bankSwiftCtrl),
                  const SizedBox(height: 20),
                  const Text('Bank Sort Code'),
                  CustTextField(controller: bankSortCtrl),
                  const SizedBox(height: 20),
                  const Text('IBAN'),
                  CustTextField(controller: ibanCtrl),
                  const SizedBox(height: 20),
                  const Text('CryptoCurrency Type'),
                  CustTextField(controller: cryptocurrencyCtrl),
                  const SizedBox(height: 20),
                  const Text('Wallet Address'),
                  CustTextField(controller: walletAddCtrl),
                  Obx(
                    () => ListTile(
                      title: const Text('Payment Type'),
                      trailing: GestureDetector(
                        onTap: () {
                          allRepos.showPicker(
                            context,
                            children: withdrawalMethods,
                            hasTrns: false,
                            onChanged: (String? val) {
                              Get.find<PayoutController>().setMethod(val!);
                            },
                            onSelectedItemChanged: (int? index) {
                              String currency = withdrawalMethods[index!];
                              Get.find<PayoutController>().setMethod(currency);
                            },
                          );
                        },
                        child: Text(Get.find<PayoutController>()
                            .activePaymethod
                            .value
                            .capitalize!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              CustButton(
                onTap: () {
                  try {
                    Map body = {
                      'paypal_email': paypalEmailCtrl.text.trim(),
                      'currency': currencyCtrl.text.trim(),
                      'country_issued': countryIssuedCtrl.text.trim(),
                      'account_name': accountNameCtrl.text.trim(),
                      'bank_name': bankNameCtrl.text.trim(),
                      'account_number': accountNumCtrl.text.trim(),
                      'swift_code': bankSwiftCtrl.text.trim(),
                      'sort_code': bankSortCtrl.text.trim(),
                      'iban': ibanCtrl.text.trim(),
                      'cryptocurrency': cryptocurrencyCtrl.text.trim(),
                      'wallet_address': walletAddCtrl.text.trim(),
                      'payment_method':
                          Get.find<PayoutController>().activePaymethod.value,
                    };

                    if (data == null) {
                      allRepos.addNewPayoutMethod(body);
                    } else {
                      body['id'] = data!['id'].toString();

                      allRepos.updatePayoutMethod(body);
                    }
                  } catch (e) {
                    allRepos.showFlush(defaultError, success: false);
                  }
                },
                title: data == null
                    ? 'Add Payment Account'
                    : 'Update Payment Method',
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
