import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/routes/ResetPassword.dart';
import 'package:shop/routes/home.dart';
import 'package:shop/routes/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void signUp(String email, String password, String name) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      user?.updateDisplayName(name);
      if (FirebaseAuth.instance.currentUser!.email != null) {
        Get.offAll(HomePage());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "unknown") {
        setState(() {
          loding = false;
        });
        Alert(context: context, title: "unknown", desc: e.message).show();
      } else if (e.code == "invalid-email") {
        setState(() {
          loding = false;
        });
        Alert(context: context, title: "invalid-email", desc: e.message).show();
      } else if (e.code == "weak-password") {
        setState(() {
          loding = false;
        });
        Alert(context: context, title: "weak-password", desc: e.message).show();
      } else if (e.code == "email-already-in-use") {
        setState(() {
          loding = false;
        });
        Alert(context: context, title: "email-already-in-use", desc: e.message)
            .show();
      }
      print("Erorrrrrrr: ${e.code}");
      print("Erorrrrrrr: ${e.message}");
    }
  }

  final _Name = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loding = false;
  String get email => _emailController.text.trim();
  String get password => _passwordController.text.trim();
  String get name => _Name.text.trim();
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              color: const Color(0xFF497fff)),
          ListView(children: [
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "ثبت نام",
                        style: TextStyle(
                            fontFamily: 'Vazir',
                            package: 'persian_fonts',
                            color: Color.fromARGB(237, 255, 255, 255),
                            fontSize: 28,
                            fontWeight: FontWeight.w700),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(237, 255, 255, 255),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            )),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.19,
                              width: MediaQuery.of(context).size.width * 0.8,
                              // color: Colors.green,
                              child: Image.asset("assets/login.png"),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, right: 20, left: 20),
                                  child: const Text("نام مستعار:",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontFamily: 'Vazir',
                                          package: 'persian_fonts',
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            Container(
                              height: 35,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _Name,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "نام مستعار",
                                      hintStyle: TextStyle(
                                          color: Color(0xFFC7C7CD),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, right: 20, left: 20),
                                  child: const Text("ایمیل:",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontFamily: 'Vazir',
                                          package: 'persian_fonts',
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            Container(
                              height: 35,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "example@gmail.com",
                                      hintStyle: TextStyle(
                                          color: Color(0xFFC7C7CD),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, right: 20, left: 20),
                                  child: const Text("کلمه عبور:",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(
                                          fontFamily: 'Vazir',
                                          package: 'persian_fonts',
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                            Container(
                              height: 35,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBEBEB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _passwordController,
                                  obscuringCharacter: "*",
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "کلمه عبور",
                                      hintStyle: TextStyle(
                                          fontFamily: 'Vazir',
                                          package: 'persian_fonts',
                                          color: Color(0xFFC7C7CD),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 30, top: 10),
                                  child: InkWell(
                                      onTap: () {
                                        Get.to(ResetPasswordPage());
                                      },
                                      child: const Text(
                                        "کلمه عبور خود را فراموش کردید؟",
                                        style: TextStyle(
                                            fontFamily: 'Vazir',
                                            package: 'persian_fonts',
                                            color: Colors.blueAccent),
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  loding = true;
                                });
                                signUp(email, password, name);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                decoration: const BoxDecoration(
                                    color: Color(0xFF497fff),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: loding ? false : true,
                                        child: const Text(
                                          "ثبت نام",
                                          style: TextStyle(
                                              fontFamily: 'Vazir',
                                              package: 'persian_fonts',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Visibility(
                                          visible: loding ? true : false,
                                          child: const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(const LoginPage());
                                  },
                                  child: const Text("ورود  ",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15,
                                      )),
                                ),
                                const Text(
                                  "من اکانت دارم!! ",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: 'Vazir',
                                    package: 'persian_fonts',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ])
        ],
      )),
    );
 
  }
}
