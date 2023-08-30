import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/routes/signUp.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  final _emailController = TextEditingController();
  String get email => _emailController.text.trim();
  bool loding = false;
  Future ResetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Password reset link sent! Check your email"),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        loding = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

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
                        "بازنشانی کلمه عبور",
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
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.text,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "ایمیل",
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
                            const SizedBox(
                              height: 10.0,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  loding = true;
                                });
                                ResetPassword(email);
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
                                          "بازنشانی",
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
                                    Get.to(SignUpPage());
                                  },
                                  child: const Text("ثبت نام ",
                                      style: TextStyle(
                                          fontFamily: 'Vazir',
                                          package: 'persian_fonts',
                                          fontSize: 15,
                                          color: Colors.blueAccent)),
                                ),
                                const Text("آیا حساب کاربری ندارید؟",
                                    style: TextStyle(
                                        fontFamily: 'Vazir',
                                        package: 'persian_fonts')),
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
