import 'package:flutter/material.dart';
import 'package:forex_guru/widgets/cust_prog_ind.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class LazyLoadWid extends StatelessWidget {
  const LazyLoadWid({
    Key? key,
    required this.isLoading,
    required this.data,
    required this.lData,
    required this.onEndOfPage,
    required this.itemBuilder,
    this.physics,
    this.padding,
    this.height = 0.8,
  }) : super(key: key);

  final bool isLoading;
  final List<dynamic>? data;
  final dynamic lData;

  final Function() onEndOfPage;
  final Widget Function(BuildContext, int) itemBuilder;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final double? height;
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;

    return Column(
      children: [
        LazyLoadScrollView(
          isLoading: isLoading,
          onEndOfPage: onEndOfPage,
          child: SizedBox(
            height: med.height * height!,
            child: ListView.builder(
              // shrinkWrap: true,
              physics: physics,
              padding: padding,
              itemCount:

                  // itemCount: snapshot.data == null ||
                  //         snapshot.data!.isEmpty
                  //     ? 0
                  //     : snapshot.data!['free'].length,
                  (data == null || data!.isEmpty)
                      ? 0
                      : (lData.length < data!.length)
                          ? lData.length
                          : data!.length,
              itemBuilder: itemBuilder,
            ),
          ),
        ),
        isLoading ? const CustProgIndicator() : const SizedBox.shrink(),
      ],
    );
  }
}
