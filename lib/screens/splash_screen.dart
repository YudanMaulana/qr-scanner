import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:y_Scanner/screens/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.fadeIn(
        duration: Duration(milliseconds: 3200),
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
                        color: Color.fromRGBO(83, 83, 83, 1),
                        fontSize: 17,
                        fontFamily: 'Agne',
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                              speed: Duration(milliseconds: 120),
                              ' Y Scanner',
                              textStyle: TextStyle(fontSize: 25)),
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
        backgroundColor: Colors.white,
        nextScreen: HomeScreen(),
      ),
    );
  }
}
