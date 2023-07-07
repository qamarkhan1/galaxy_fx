import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/svg.dart';
import 'package:forex_guru/screens/start_page.dart';
import 'package:forex_guru/utils/colors.dart';
import 'package:introduction_slider/introduction_slider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return IntroductionSlider(
      items: [
        IntroductionSliderItem(
          logo: SvgPicture.asset('assets/svgs/bear.svg'),
          title: const Text(
            "Daily Signals",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Get free forex daily signals'),
        ),
        IntroductionSliderItem(
          logo: SvgPicture.asset('assets/svgs/invest.svg'),
          title: const Text(
            "Investments",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Invest and earn interests'),
        ),
        IntroductionSliderItem(
          logo: SvgPicture.asset('assets/svgs/calendar.svg'),
          title: const Text(
            "Subscriptions",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Subscribe to get Premium signals'),
        ),
        IntroductionSliderItem(
          logo: SvgPicture.asset('assets/svgs/refer.svg'),
          title: const Text(
            "Refer and Earn",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text('Get paid for telling a friend'),
        ),
      ],
      done: Done(
        child: const Icon(IconlyBold.send),
        home: StartPageScreen(),
      ),
      // scrollDirection: Axis.vertical,
      next: const Next(child: Icon(Icons.arrow_forward)),
      back: const Back(child: Icon(Icons.arrow_back)),
      dotIndicator: DotIndicator(
        selectedColor: primaryColor,
        unselectedColor: accent,
      ),
    );
  }
}
