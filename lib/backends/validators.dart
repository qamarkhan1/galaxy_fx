abstract class BaseValidators {
  String? validateEmpty(String? valu);
  String? validateName(String? value);
  String? validateEmail(String? value);
  String? validatePassword(String? value);
  String? validateCPassword(String value, String password);

  String? validateAmount(
    bool hasBal,
    String value,
    double balance,
    double minimum,
    double maximum,
  );
}

class ValidatorsFxn implements BaseValidators {
  @override
  String? validateEmpty(String? value) {
    if (value!.trim().isEmpty) {
      return 'Field is Required';
    }
    return null;
  }

  @override
  String? validateName(String? value) {
    if (value!.trim().isEmpty) {
      return "Name is Required";
    } else if (value.trim().length < 2) {
      return "Invalid name length";
    }
    return null;
  }

  @override
  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value!.trim().isEmpty) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  @override
  String? validatePassword(String? value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (value!.trim().isEmpty) {
      return "Password is Required";
    } else if (!regExp.hasMatch(value.trim())) {
      return "Upper,Lower Case, Number and Special chars";
    }
    return null;
  }

  @override
  String? validateCPassword(String? value, String? password) {
    if (value!.trim().isEmpty) {
      return "Confirm Password is Required";
    } else if (value != password) {
      return "Passwords don't match";
    }
    return null;
  }

  @override
  String? validateAmount(bool? hasBal, String? value, double? balance,
      double? minimum, double? maximum) {
    if (value == null || value == "" || value == ".") {
      return "Invalid amount";
    } else if (double.parse(value) < minimum!) {
      return "Amount less than minimum";
    } else if (double.parse(value) > maximum!) {
      return "Amount greater than maximum";
    } else if (hasBal! && (double.parse(value) > balance!)) {
      return "Amount greater than balance";
    }

    return null;
  }
}
