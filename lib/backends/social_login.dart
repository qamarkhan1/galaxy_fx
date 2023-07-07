import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

abstract class BaseSocialLogin {
  Future<Web3AuthResponse> withGoogle();
  Future<Web3AuthResponse> withFacebook();
  Future<Web3AuthResponse> withTwitter();
  Future<Web3AuthResponse> withApple();
}

class SocialLogin implements BaseSocialLogin {
  @override
  Future<Web3AuthResponse> withGoogle() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.google));
  }

  @override
  Future<Web3AuthResponse> withFacebook() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.facebook));
  }

  @override
  Future<Web3AuthResponse> withTwitter() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.twitter));
  }

  @override
  Future<Web3AuthResponse> withApple() {
    return Web3AuthFlutter.login(LoginParams(loginProvider: Provider.apple));
  }
}
