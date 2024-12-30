import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:y_Scanner/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FlutterSplashScreen.fadeIn(
        duration: Duration(milliseconds: 3300),
        childWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 250),
                  SizedBox(
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Agne',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                              speed: Duration(milliseconds: 120),
                              'scan and save everywhere',
                              textStyle: TextStyle(fontSize: 20)),
                        ],
                        isRepeatingAnimation: false,
                        onTap: () {
                          print("Tap Event");
                        },
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/icon.png',
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 5),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Text(
                  'by yudan maulana',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        nextScreen: HomeScreen(),
      ),
    );
  }
}
