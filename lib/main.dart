import 'package:bon_voyage/screens/asl_screen.dart';
import 'package:bon_voyage/screens/camera_screen.dart';
import 'package:bon_voyage/screens/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Yomogi',
        primaryColor: Color(0xFFADD8E6),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        CameraScreen.id: (context) => CameraScreen(),
        ASLScreen.id: (context) => ASLScreen(),
      },
    );
  }
}
