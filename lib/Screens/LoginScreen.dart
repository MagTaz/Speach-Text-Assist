// ignore_for_file: dead_code

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speach_text_assist/Screens/HomeScreen.dart';
import 'package:speach_text_assist/Screens/SignUpScreen.dart';
import 'package:speach_text_assist/Services/UserServices.dart';
import 'package:speach_text_assist/Utils/ButtonStyle.dart';
import 'package:speach_text_assist/Utils/MainColors.dart';
import 'package:speach_text_assist/Utils/TextFieldStyle.dart';
import 'package:speach_text_assist/Utils/TextStyle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool _isVisable = true;
Color mainColor = MainColors.MainColor;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  // صورة الخلفية
                  Image.asset(
                    "assets/images/welcomeBackground.png",
                    fit: BoxFit.cover,
                    width: width,
                    height: height,
                  ),
                  // تأثير التمويه باستخدام BackdropFilter
                  BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5, sigmaY: 5), // تمويه على المحورين
                    child: Container(
                      color: Colors.black54, // شفافية لإظهار التأثير
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Stack(
                children: [
                  SafeArea(
                    child: SizedBox(
                      height: height * 0.2,
                      child: Align(
                        alignment: Alignment.center,

                        // الشعار
                        child: Image.asset(
                          "assets/images/logo1.png",
                          fit: BoxFit.cover,
                          height: height * 0.18,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Container(
                        height: height * 0.7,
                        width: width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  spreadRadius: 5,
                                  blurRadius: 20)
                            ]),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            //العناصر على شكل عامودي

                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Login",
                                style: Text_Style.textStyleBold(
                                    MainColors.MainColor, 35),
                              ),
                              const Spacer(),
                              emailTextField(MainColors.MainColor),
                              const SizedBox(
                                height: 30,
                              ),
                              passwordTextField(MainColors.MainColor),
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: MainColors.MainColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black38,
                                        spreadRadius: 1,
                                        blurRadius: 30,
                                      )
                                    ]),
                                child: TextButton(
                                    onPressed: _isLoading == true
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              await UserServices()
                                                  .Login(
                                                      _emailController.text
                                                          .trim(),
                                                      _passwordController.text
                                                          .trim())
                                                  .then((value) {
                                                if (value != null) {
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const HomeScreen()),
                                                      ((route) => false));
                                                }
                                              });
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            }
                                          },
                                    child: Container(
                                        width: width,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: _isLoading == true
                                            ? Center(
                                                child: SpinKitThreeBounce(
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                "Login",
                                                textAlign: TextAlign.center,
                                                style: Text_Style.textStyleBold(
                                                    Colors.white, 20),
                                              ))),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an Acount",
                                    style: Text_Style.textStyleNormal(
                                        Colors.black, 12.5),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const SignUpScreen();
                                        }));
                                      },
                                      child: Text("  Sign Up",
                                          style: Text_Style.textStyleBold(
                                              MainColors.MainColor, 15))),
                                  const SizedBox(
                                    height: 130,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  TextFormField emailTextField(Color color) {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter an email';
          } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
              .hasMatch(value)) {
            return 'Please enter a valid email';
          }
          return null;
        },
        style: Text_Style.textStyleNormal(Colors.black, 18),
        enabled: !_isLoading,
        controller: _emailController,
        obscureText: false,
        decoration: TextFieldStyle().primaryTexrField("Email",
            const Icon(Icons.email), MainColors.MainColor, Colors.black54));
  }

  TextFormField passwordTextField(Color color) {
    return TextFormField(
        obscureText: _isVisable,
        validator: (value) {
          if (value!.isEmpty) {
            return "Empty Password";
          }
          return null;
        },
        style: Text_Style.textStyleNormal(Colors.black, 18),
        enabled: !_isLoading,
        controller: _passwordController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: ("password"),
          hintStyle: Text_Style.textStyleNormal(Colors.black54, 18),
          prefixIcon: const Icon(Icons.lock),
          prefixIconColor: MainColors.MainColor,
          suffixIconColor: MainColors.MainColor,
          suffixIcon: IconButton(
            icon: _isVisable
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                _isVisable = !_isVisable;
              });
            },
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: MainColors.MainColor.withOpacity(0.6),
                width: 1.9,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ));
  }
}
