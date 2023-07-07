import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/two_fa_ctrl.dart';

class TwoFaScreen extends GetView {
  const TwoFaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TwoFaCtrl twoFaCtrl = Get.put(TwoFaCtrl());

    final pinController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return CustScaffold(
      title: '',
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                title: Text(
                  'Two Factor Authentication',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'To be able to authorize transactions you need to scan this QR code with your Google Authentication App and enter the verification code below',
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                height: 200,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .color!
                          .withOpacity(0.5),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: QrImage(
                    data: "1234567890",
                    version: QrVersions.auto,
                    size: 150.0,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Verification Code'),
                    const SizedBox(height: 10),
                    Pinput(
                      length: 6,
                      controller: pinController,
                      focusNode: twoFaCtrl.focusNode,
                      // androidSmsAutofillMethod:
                      //     AndroidSmsAutofillMethod.smsUserConsentApi,
                      listenForMultipleSmsOnAndroid: true,
                      // defaultPinTheme: defaultPinTheme,
                      validator: (value) {
                        return value == '2222' ? null : 'Pin is incorrect';
                      },
                      // onClipboardFound: (value) {
                      //   debugPrint('onClipboardFound: $value');
                      //   pinController.setText(value);
                      // },
                      hapticFeedbackType: HapticFeedbackType.lightImpact,
                      onCompleted: (pin) {
                        debugPrint('onCompleted: $pin');
                      },
                      onChanged: (value) {
                        debugPrint('onChanged: $value');
                      },
                      cursor: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 9),
                            width: 22,
                            height: 1,
                            color: green,
                          ),
                        ],
                      ),
                      // focusedPinTheme: defaultPinTheme.copyWith(
                      //   decoration: defaultPinTheme.decoration!.copyWith(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: focusedBorderColor),
                      //   ),
                      // ),
                      // submittedPinTheme: defaultPinTheme.copyWith(
                      //   decoration: defaultPinTheme.decoration!.copyWith(
                      //     color: fillColor,
                      //     borderRadius: BorderRadius.circular(19),
                      //     border: Border.all(color: focusedBorderColor),
                      //   ),
                      // ),
                      // errorPinTheme: defaultPinTheme.copyBorderWith(
                      //   border: Border.all(color: red),
                      // ),
                    ),
                    const SizedBox(height: 20),
                    CustButton(
                        onTap: () => formKey.currentState!.validate(),
                        title: 'Next'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
