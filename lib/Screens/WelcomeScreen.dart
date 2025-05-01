import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:speach_text_assist/Screens/LoginScreen.dart';
import 'package:speach_text_assist/Screens/SignUpScreen.dart';
import 'package:speach_text_assist/Utils/MainColors.dart';
import 'package:speach_text_assist/Utils/TextStyle.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: widthScreen,
            height: heightScreen,
            child: Stack(
              children: [
                // صورة الخلفية
                Image.asset(
                  "assets/images/welcomeBackground.png",
                  fit: BoxFit.cover,
                  width: widthScreen,
                  height: heightScreen,
                ),
                // تأثير التمويه باستخدام BackdropFilter
                BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 5, sigmaY: 5), // تمويه على المحورين
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Center(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      width: widthScreen * .6,
                      child: Lottie.asset(
                          "assets/animations/welcomeScreenAnimation.json",
                          repeat: true,
                          reverse: true,
                          fit: BoxFit.contain)),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment
                      .center, // Center-aligns content within the container
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text.rich(
                      TextSpan(
                        text: 'Welcome!\n',
                        style: Text_Style.textStyleBold(Colors.white, 50),
                        children: [
                          TextSpan(
                            text:
                                'Transform spoken words into written text effortlessly with precision and speed.',
                            style:
                                Text_Style.textStyleNormal(Colors.white70, 16),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center, // Aligns text at the center
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }));
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: widthScreen,
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 20,
                              color: Colors.black54)
                        ],
                        gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Login",
                            style: Text_Style.textStyleBold(
                                MainColors.AccentColor, 25),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 30,
                            color: MainColors.AccentColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Acount?",
                      style: Text_Style.textStyleNormal(Colors.white, 12.5),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return const SignUpScreen();
                          }));
                        },
                        child: Text(" Sign Up",
                            style: Text_Style.textStyleBold(
                                MainColors.SecondryColor, 14))),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
