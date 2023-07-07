import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/colors.dart';

class CustTextField extends StatelessWidget {
  const CustTextField({
    Key? key,
    this.controller,
    this.initialValue,
    this.hintText,
    this.mHintText,
    this.lableText,
    this.mLableText,
    this.onChanged,
    this.prefix,
    this.prefixIcon,
    this.suffix,
    this.width,
    this.enabled,
    this.suffixIcon,
    this.obscureText,
    this.counter,
    this.focusNode,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.prefixText,
    this.readOnly,
    this.style,
    this.suffixText,
    this.textAlign,
    this.textInputAction,
    this.validator,
    this.hintTrns = false,
    this.args,
  }) : super(key: key);

  final String? initialValue;
  final TextEditingController? controller;
  final Function(String?)? onChanged;
  final String? hintText;
  final List<String>? mHintText;
  final String? lableText;
  final List<String>? mLableText;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;

  final bool? enabled;
  final bool? readOnly;
  final int? maxLines;
  final String? prefixText;
  final String? suffixText;
  final String? Function(String?)? validator;
  final bool? obscureText;

  final TextStyle? style;
  final TextAlign? textAlign;

  final double? width;

  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Widget? counter;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool hintTrns;
  final Map<String, String>? args;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        obscureText: obscureText ?? false,
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
        enabled: enabled ?? true,
        focusNode: focusNode,
        textAlign: textAlign ?? TextAlign.left,
        validator: validator,
        maxLines: maxLines ?? 1,
        readOnly: readOnly ?? false,
        style: style,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          labelText:
              // hintTrns
              //     ? _allBackEnds.multiTranslation(
              //         context, mLableText ?? [lableText!],
              //         args: args)
              //     :
              lableText,
          labelStyle: const TextStyle(
              // color: white,
              ),
          counterText: "",
          isDense: true,
          hintText:
              //  hintTrns
              //     ? _allBackEnds.multiTranslation(context, mHintText ?? [hintText!],
              //         args: args)
              //     :
              hintText,
          prefix: prefix,
          prefixIcon: prefixIcon,
          suffix: suffix,
          suffixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: grey,
              width: 0.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: grey,
              width: 0.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: grey,
              // width: 0.0,
            ),
          ),
        ),
      ),
    );
  }
}
