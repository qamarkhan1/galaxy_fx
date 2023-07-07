import 'package:get/get.dart';

class AuthController extends GetxController {
  final biometricsStatus = true.obs;
  final trxnAuthStatus = true.obs;

  void biometricsStatusFxn(bool isActive) {
    biometricsStatus(isActive);
  }

  void trxnAuthStatusFxn(bool isActive) {
    trxnAuthStatus(isActive);
  }
}
