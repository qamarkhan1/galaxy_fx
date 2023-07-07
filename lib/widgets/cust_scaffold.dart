import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:forex_guru/widgets/cust_prog_ind.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustScaffold extends GetView {
  const CustScaffold({
    Key? key,
    required this.body,
    this.title,
    this.actions,
    this.backgroundColor,
    this.leading,
    this.onRefresh,
    this.isLoading = false,
  }) : super(key: key);

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Widget? leading;
  final bool? isLoading;
  final Future<void> Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async => {},
      child: LoadingOverlay(
        isLoading: isLoading!,
        progressIndicator: const CustProgIndicator(),
        child: Scaffold(
          appBar: title != null
              ? AppBar(
                  leading: leading ??
                      IconButton(
                        icon: Icon(
                          Feather.x,
                          color: backgroundColor == null && title != ''
                              ? null
                              : primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                  elevation: 0.0,
                  title: Text(title!),
                  actions: actions,
                  backgroundColor: backgroundColor ??
                      (title == '' ? transparent : primaryColor),
                )
              : null,
          body: body,
        ),
      ),
    );
  }
}
