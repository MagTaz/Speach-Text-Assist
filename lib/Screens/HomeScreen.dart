import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:speach_text_assist/Screens/WelcomeScreen.dart';
import 'package:speach_text_assist/Utils/MainColors.dart';
import 'package:speach_text_assist/Utils/TextStyle.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  final GoogleTranslator translator = GoogleTranslator();
  late stt.SpeechToText _speech; // Instance of speech_to_text

  String _text = "";
  String _translatedText = "";
  String chosenLanguage = "Arabic";
  String translateCode = "ar";
  final User? user = _auth.currentUser;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    _speech = stt.SpeechToText();
    super.initState();
  }

  // Start or stop listening for speech
  Future<void> _listen() async {
    await _speech.initialize();
    setState(() {
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
          _translateText(_text); // ترجمة النص بعد الاستماع إليه
          _scrollToBottom();
        }),
      );
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

// دالة ترجمة النص
  void _translateText(String text) async {
    try {
      final translation = await translator.translate(text, to: translateCode);
      setState(() {
        _translatedText = translation.text; // تحديث النص المترجم
      });
    } catch (e) {
      print("Translation error: $e");
    }
  }

  void _stopListen() {
    setState(() {
      _speech.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              height: heightScreen * 0.35,
              width: widthScreen,
              decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(50)),
                  gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlue])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Spacer(),
                  if (_speech.isListening)
                    const SpinKitWave(
                      color: Colors.white54,
                      size: 50,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Press ",
                          style: Text_Style.textStyleNormal(Colors.white54, 18),
                        ),
                        const Icon(
                          Icons.mic,
                          color: Colors.white54,
                        ),
                        Text(
                          " to record your voice",
                          style: Text_Style.textStyleNormal(Colors.white54, 18),
                        )
                      ],
                    ),
                  Spacer(),
                  IconButton(
                    icon: _speech.isListening
                        ? Icon(
                            Icons.square,
                            color: Colors.red,
                            size: 40,
                          )
                        : Icon(
                            Icons.mic,
                            size: 40,
                            color: Colors.white,
                          ),
                    onPressed: _speech.isListening ? _stopListen : _listen,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: heightScreen * 0.65,
              width: widthScreen,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0)),
                  color: Colors.blueAccent),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(10),
              height: heightScreen * 0.65,
              width: widthScreen,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                  color: Colors.white),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: widthScreen,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 5,
                              blurRadius: 10)
                        ],
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.volume_up),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              "English",
                              style:
                                  Text_Style.textStyleBold(Colors.black54, 16),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: _text));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Text copied to clipboard")),
                                  );
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                        SizedBox(
                          width: widthScreen,
                          height: 70,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Text(
                              _text,
                              style:
                                  Text_Style.textStyleNormal(Colors.black, 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: widthScreen,
                    height: 180,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 5,
                              blurRadius: 10)
                        ],
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.volume_up),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              chosenLanguage,
                              style:
                                  Text_Style.textStyleBold(Colors.black54, 16),
                            ),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: _translatedText));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Text copied to clipboard")),
                                  );
                                },
                                icon: const Icon(Icons.copy))
                          ],
                        ),
                        SizedBox(
                          width: widthScreen,
                          height: 70,
                          child: SingleChildScrollView(
                            controller: _scrollController2,
                            child: Text(
                              _translatedText,
                              style:
                                  Text_Style.textStyleNormal(Colors.black, 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlue, Colors.blueAccent]),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: widthScreen * 0.8,
                    height: 80,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          width: widthScreen * 0.35,
                          height: 80,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Text(
                              "English",
                              style: Text_Style.textStyleBold(Colors.white, 16),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(3),
                          width: widthScreen * 0.35,
                          height: 80,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: TextButton(
                            onPressed: () {
                              // إظهار مربع حوار لاختيار اللغة
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Choose Language'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Arabic'),
                                          onTap: () {
                                            // تغيير اللغة إلى العربية هنا
                                            setState(() {
                                              chosenLanguage = "Arabic";
                                              translateCode = "ar";
                                            });
                                            _translateText(_text);
                                            Navigator.of(context).pop();

                                            // قم بتحديث اللغة هنا باستخدام الـ setState أو أي طريقة تستخدمها
                                          },
                                        ),
                                        ListTile(
                                          title: Text('French'),
                                          onTap: () {
                                            setState(() {
                                              chosenLanguage = "French";
                                              translateCode = "fr";
                                            });
                                            _translateText(_text);

                                            // تغيير اللغة إلى الفرنسية هنا
                                            Navigator.of(context).pop();
                                            // قم بتحديث اللغة هنا باستخدام الـ setState أو أي طريقة تستخدمها
                                          },
                                        ),
                                        ListTile(
                                          title: Text('German'),
                                          onTap: () {
                                            setState(() {
                                              chosenLanguage = "German";
                                              translateCode = "de";
                                            });
                                            _translateText(_text);

                                            // تغيير اللغة إل الألمانية هنا
                                            Navigator.of(context).pop();
                                            // قم بتحديث اللغة هنا باستخدام الـ setState أو أي طريقة تستخدمها
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Center(
                              child: Text(
                                chosenLanguage,
                                style: Text_Style.textStyleBold(
                                    Colors.blueAccent, 16),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 20,
            child: SafeArea(
              child: PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      enabled: false,
                      child: Text(
                        "${user!.displayName}",
                        style: Text_Style.textStyleBold(Colors.black45, 16),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sign out",
                            style: Text_Style.textStyleNormal(
                                MainColors.MainColor, 15),
                          ),
                          Spacer(),
                          Icon(
                            Iconsax.logout_1_copy,
                            color: MainColors.MainColor.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'logout') {
                    _auth.signOut();
                    setState(() {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                          ((route) => false));
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.lightBlue,
                      child: Center(
                          child: Text(
                        user!.displayName.toString()[0],
                        style: Text_Style.textStyleBold(Colors.white, 20),
                      ))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
