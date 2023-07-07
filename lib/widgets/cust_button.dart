import 'package:flutter/material.dart';
import 'package:forex_guru/utils/colors.dart';

class CustButton extends StatelessWidget {
  const CustButton({
    Key? key,
    required this.onTap,
    this.title,
    this.width,
    this.color,
    this.textColor,
    this.isHollow = false,
    this.args,
    this.borderRadius,
    this.child,
  }) : super(key: key);
  final void Function()? onTap;
  final String? title;
  final double? width;
  final Color? color;
  final Color? textColor;
  final bool isHollow;
  final Map<String, String>? args;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 50,
        decoration: BoxDecoration(
          // ignore: prefer_if_null_operators
          color: color != null
              ? color
              : isHollow
                  ? transparent
                  : primaryColor,
          borderRadius: borderRadius ?? BorderRadius.circular(5),
          border: Border.all(
            color: isHollow
                ? Theme.of(context).colorScheme.secondary
                : transparent,
          ),
        ),
        child: child ??
            Center(
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  // ignore: prefer_if_null_operators
                  color: textColor != null
                      ? textColor
                      : isHollow
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
      ),
    );
  }
}
