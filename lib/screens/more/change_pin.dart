import 'package:flutter/material.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:forex_guru/widgets/cust_tile.dart';
import 'package:forex_guru/widgets/previous_stack_wid.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinput/pinput.dart';
import 'package:forex_guru/utils/config.dart';

import '../../controllers/change_pin_ctrl.dart';
import '../../utils/strings.dart';

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(fontSize: 22),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(19),
    border: Border.all(color: borderColor),
  ),
);

class ChangePin extends GetView {
  const ChangePin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChangePinCtrl changePinController = Get.put(ChangePinCtrl());

    var settingsBx = Hive.box(settings);
    var lockPinBx = settingsBx.get(lockPin);
    String? currentPin = lockPinBx;
    bool activePinCodeBx = settingsBx.get(activePinCode) ?? false;

    Get.find<ChangePinCtrl>().activatePin.value = activePinCodeBx;

    Size med = MediaQuery.of(context).size;

    changePinController.newIndex.value = currentPin == null ? 1 : 0;
    return CustScaffold(
      title: '',
      body: ListView(
        children: [
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              height: med.height,
              padding: const EdgeInsets.all(defaultPadding),
              child: Obx(
                () => IndexedStack(
                  index: changePinController.newIndex.value,
                  children: [
                    stackOne(changePinController,
                        currentPin == null ? true : false, context),
                    stackTwo(changePinController, currentPin,
                        currentPin == null ? true : false),
                    stackThree(changePinController, settingsBx,
                        currentPin == null ? true : false),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  stackOne(ChangePinCtrl changePinController, bool isNewPin, context) {
    AllRepos allRepos = AllRepos();

    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Card(
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PIN Settings',
                style: Theme.of(context).textTheme.headline6,
              ),
              CustTile(
                title: 'Activate PIN',
                trailing: allRepos.toggleSwitch(
                    changePinController.activatePin.value, (bool val) {
                  changePinController.setActivePin(val);
                }),
              ),
              CustTile(
                onTap: () {
                  changePinController.changeIndex(true, 0);
                },
                title: 'Change Pin',
                trailing: GestureDetector(
                  child: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  stackTwo(ChangePinCtrl changePinController, currentPin, bool isNewPin) {
    // String? inputPin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(
            isNewPin ? 'Set New PIN' : 'Change your PIN',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle:
              Text(isNewPin ? 'Enter Your Pin' : 'Enter Your Current Pin'),
        ),
        const SizedBox(height: 200),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              controller: changePinController.pinController,
              focusNode: changePinController.focusNode,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                if (!isNewPin) {
                  if (value == currentPin) {
                    return null;
                  } else {
                    return 'Pin is incorrect';
                  }
                }
                if (value!.length == 4) {
                  return null;
                } else {
                  return 'Invalid Lenght';
                }
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                if (!isNewPin) {
                  if (pin == currentPin) {
                    changePinController.setInputPin(pin);
                  }
                } else {
                  changePinController.setInputPin(pin);
                }
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: red),
              ),
            ),
            const SizedBox(height: 20),
            CustButton(
              onTap: () {
                if (!isNewPin) {
                  if (changePinController.inputPin.value == currentPin) {
                    changePinController.changeIndex(true, 1);
                  }
                } else {
                  if (changePinController.inputPin.value.length == 4) {
                    changePinController.changeIndex(true, 1);
                  }
                }
              },
              title: 'Next',
            ),
            PreviousStackWid(onTap: () {
              changePinController.changeIndex(false, 1);
            }),
          ],
        ),
      ],
    );
  }

  stackThree(changePinController, settingsBx, bool isNewPin) {
    AllRepos allRepos = AllRepos();
    String? newPin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ListTile(
          title: Text(
            isNewPin ? 'Set New PIN' : 'Change your PIN',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(isNewPin ? 'Re-Enter Your Pin' : 'Enter Your New Pin'),
        ),
        const SizedBox(height: 200),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Pinput(
              controller: changePinController.pinController,
              focusNode: changePinController.focusNode,
              listenForMultipleSmsOnAndroid: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                if (isNewPin) {
                  if (value == changePinController.inputPin.value) {
                    return null;
                  } else {
                    return "PIN inputs don't match";
                  }
                }
                if (value!.length == 4) {
                  return null;
                } else {
                  return 'Invalid Lenght';
                }
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                if (isNewPin) {
                  if (changePinController.inputPin.value == pin) {
                    newPin = pin;
                  }
                } else {
                  newPin = pin;
                }
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyBorderWith(
                border: Border.all(color: red),
              ),
            ),
            const SizedBox(height: 20),
            CustButton(
              onTap: () {
                if (newPin!.length == 4) {
                  settingsBx.put(lockPin, newPin);
                  allRepos.showFlush(
                      isNewPin ? 'PIN Set Success' : 'PIN Change Success',
                      success: true);
                  changePinController.changeIndex(false, 1);
                }
              },
              title: isNewPin ? 'Set PIN' : 'Change PIN',
            ),
            PreviousStackWid(onTap: () {
              changePinController.changeIndex(false, 2);
            }),
          ],
        ),
      ],
    );
  }
}
