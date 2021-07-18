import 'package:bon_voyage/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

class SplashScreen extends StatelessWidget {
  static const String id = "splash_screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: CameraScreen(),
      duration: 4000,
      imageSize: 400,
      speed: 2,
      pageRouteTransition: PageRouteTransition.SlideTransition,
      imageSrc: "images/splash_image.png",
      text: "SignPrism",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 50.0,
        color: Colors.white,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Color(0xFFADD8E6),
    );
  }
}
