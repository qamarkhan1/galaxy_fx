import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/backends/all_repos.dart';
import 'package:forex_guru/utils/config.dart';
import 'package:forex_guru/utils/strings.dart';
import 'package:forex_guru/widgets/cust_button.dart';
import 'package:forex_guru/widgets/cust_scaffold.dart';
import 'package:get/get.dart';

import '../../controllers/change_pass_ctrl.dart';
import '../../widgets/cust_text_field.dart';

class ChangePassword extends GetView {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllRepos allRepos = AllRepos();

    TextEditingController currentPassCtrl = TextEditingController();
    TextEditingController newPassCtrl = TextEditingController();
    TextEditingController confirmPassCtrl = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey();
    final ChangePassCtrl changePassCtrl = Get.put(ChangePassCtrl());

    Size med = MediaQuery.of(context).size;

    return CustScaffold(
      title: '',
      body: SingleChildScrollView(
        child: Container(
          height: med.height * 0.9,
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('Change your password to a new one.'),
                      ),
                      const SizedBox(height: 50),
                      const Text('Current Password'),
                      CustTextField(
                        validator: allRepos.validateEmpty,
                        controller: currentPassCtrl,
                        obscureText: changePassCtrl.showCurrent.value,
                        suffixIcon: changePassCtrl.showCurrent.value
                            ? IconButton(
                                onPressed: () =>
                                    changePassCtrl.toggleCurrent(false),
                                icon: const Icon(
                                  Feather.eye_off,
                                  size: 20,
                                ),
                              )
                            : IconButton(
                                onPressed: () =>
                                    changePassCtrl.toggleCurrent(true),
                                icon: const Icon(
                                  Feather.eye,
                                  size: 20,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      const Text('New Password'),
                      CustTextField(
                        validator: allRepos.validatePassword,
                        controller: newPassCtrl,
                        obscureText: changePassCtrl.showNew.value,
                        suffixIcon: changePassCtrl.showNew.value
                            ? IconButton(
                                onPressed: () =>
                                    changePassCtrl.toggleNew(false),
                                icon: const Icon(
                                  Feather.eye_off,
                                  size: 20,
                                ),
                              )
                            : IconButton(
                                onPressed: () => changePassCtrl.toggleNew(true),
                                icon: const Icon(
                                  Feather.eye,
                                  size: 20,
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Confirm New Password'),
                      CustTextField(
                        validator: (String? val) {
                          return allRepos.validateCPassword(
                              val!, newPassCtrl.text.trim());
                        },
                        obscureText: changePassCtrl.showNew.value,
                        controller: confirmPassCtrl,
                        suffixIcon: changePassCtrl.showNew.value
                            ? IconButton(
                                onPressed: () =>
                                    changePassCtrl.toggleNew(false),
                                icon: const Icon(
                                  Feather.eye_off,
                                  size: 20,
                                ),
                              )
                            : IconButton(
                                onPressed: () => changePassCtrl.toggleNew(true),
                                icon: const Icon(
                                  Feather.eye,
                                  size: 20,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  CustButton(
                    onTap: () {
                      try {
                        Map body = {
                          'current_password': currentPassCtrl.text.trim(),
                          'new_password': newPassCtrl.text.trim(),
                        };
                        allRepos.changePass(body);
                      } catch (e) {
                        allRepos.showFlush(defaultError);
                      }
                    },
                    title: 'Change Password',
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
