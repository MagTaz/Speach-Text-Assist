// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:speach_text_assist/Screens/HomeScreen.dart';
import 'package:speach_text_assist/Services/UserServices.dart';
import 'package:speach_text_assist/Utils/ButtonStyle.dart';
import 'package:speach_text_assist/Utils/MainColors.dart';

import '../Utils/TextFieldStyle.dart';
import '../Utils/TextStyle.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isVisable = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            color: Colors.black12,
            child: Stack(
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
                        child: Opacity(
                          opacity: 0.4,
                          child: Container(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Container(
                          alignment: Alignment.center,
                          height: height * 0.18,
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            "assets/images/logo1.png",
                            fit: BoxFit.cover,
                            height: height * 0.13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              height: height * 0.75,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 3,
                                      color: Colors.black38,
                                      blurRadius: 30)
                                ],
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: Text_Style.textStyleBold(
                                        MainColors.MainColor, 30),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  nameTextField(MainColors.MainColor),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  numberTextField(MainColors.MainColor),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  emailTextField(MainColors.MainColor),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  passwordTextField(MainColors.MainColor),
                                  const Spacer(),
                                  Container(
                                    width: width,
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
                                    alignment: Alignment.center,
                                    child: TextButton(
                                        onPressed: _isLoading == true
                                            ? null
                                            : () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  UserServices()
                                                      .SignUp(
                                                          emailController.text
                                                              .trim(),
                                                          passwordController
                                                              .text
                                                              .trim(),
                                                          nameController.text,
                                                          numberController.text)
                                                      .then((value) {
                                                    if (value != null ||
                                                        value != "") {
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomeScreen()),
                                                          ((route) => false));
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'You signed up!!',
                                                            style: Text_Style
                                                                .textStyleBold(
                                                                    Colors
                                                                        .black,
                                                                    12),
                                                          ),
                                                          backgroundColor:
                                                              Colors.green,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                        ),
                                                      );
                                                    } else if (value == null) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          elevation: 0,
                                                          content: Text(
                                                            'This email already exists',
                                                            style: Text_Style
                                                                .textStyleBold(
                                                                    Colors
                                                                        .black,
                                                                    12),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red
                                                                  .withOpacity(
                                                                      0.8),
                                                          duration:
                                                              const Duration(
                                                                  seconds: 3),
                                                        ),
                                                      );

                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    }
                                                  });
                                                }
                                              },
                                        child: _isLoading == true
                                            ? Center(
                                                child: SpinKitThreeBounce(
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Text(
                                                "Sign up",
                                                style: Text_Style.textStyleBold(
                                                    Colors.white, 20),
                                              )),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  TextFormField nameTextField(Color color) {
    return TextFormField(
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return "please enter your name !!!";
          }
          RegExp regex = RegExp(r'^[a-zA-Z]+$');
          if (!regex.hasMatch(value)) {
            return 'Name should contain letters only!';
          }
          return null;
        },
        style: Text_Style.textStyleNormal(Colors.black, 18),
        enabled: !_isLoading,
        controller: nameController,
        obscureText: false,
        decoration: TextFieldStyle().primaryTexrField("Name",
            const Icon(Icons.account_box_rounded), color, Colors.black54));
  }

  TextFormField numberTextField(Color color) {
    return TextFormField(
        keyboardType: TextInputType.phone,
        maxLengthEnforcement: MaxLengthEnforcement.none,
        validator: (value) {
          if (value!.isEmpty) {
            return "please enter your phone number!!!";
          }
          if (value.length != 10) {
            return 'Phone number should be 10 digits long';
          }
          if (!value.startsWith('05')) {
            return 'Please enter a valid phone number';
          }

          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          LengthLimitingTextInputFormatter(10),
        ],
        style: Text_Style.textStyleNormal(Colors.black, 18),
        enabled: !_isLoading,
        controller: numberController,
        obscureText: false,
        decoration: TextFieldStyle().primaryTexrField(
            "Phone Number", const Icon(Icons.phone), color, Colors.black54));
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
        controller: emailController,
        obscureText: false,
        decoration: TextFieldStyle().primaryTexrField(
            "Email", const Icon(Icons.email), color, Colors.black54));
  }

  TextFormField passwordTextField(Color color) {
    return TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Empty Password";
          }
          return null;
        },
        style: Text_Style.textStyleNormal(Colors.black, 18),
        enabled: !_isLoading,
        controller: passwordController,
        obscureText: _isVisable,
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
