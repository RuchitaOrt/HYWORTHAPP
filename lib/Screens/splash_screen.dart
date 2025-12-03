
import 'package:flutter/material.dart';
import 'package:hyworth_land_survey/Provider/splash_provider.dart';
import 'package:hyworth_land_survey/Utils/sizeConfig.dart';

import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {
  static const String route = "/";

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
     SizeConfig().init(context);
    return ChangeNotifierProvider<SplashProvider>(
      create: (BuildContext context) {
        return SplashProvider(context);
      },
      child: Consumer<SplashProvider>(
        builder: (context, provider, _) {
          final height = MediaQuery.sizeOf(context).height;
          return Scaffold(
            
            body: Stack(
              children: [
                Center(
                  child: Container()
                  // SvgPicture.asset(
                  //   CattleImagePath.splashLogo,
                  //   height: height / 4,
                  //   width: height / 4,
                  // )
                  //     .animate(onPlay: (controller) => controller.repeat())
                  //     .fadeIn(duration: 400.ms, curve: Curves.easeIn)
                  //     .scale(duration: 500.ms, begin: const Offset(1, 1), end: const Offset(0.9, 0.9))
                  //     .then(delay: 2000.ms)
                  //     .fadeOut(curve: Curves.easeOut),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
