import 'dart:io';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop/routes/EmailAddress.dart';
import 'package:shop/routes/login.dart';
import 'package:shop/routes/password.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:shop/routes/profile.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  @override
  bool loding = false;
  final _CurrentPasswordController = TextEditingController();
  final _NewPasswordController = TextEditingController();
  final _RepeatPasswordController = TextEditingController();
  String get CurrentPassword => _CurrentPasswordController.text.trim();
  String get NewPassword => _NewPasswordController.text.trim();
  String get RepeatPassword => _RepeatPasswordController.text.trim();
  void _changePassword(
      String NewPassword, String RepeatPassword, String CurrentPassword) {
    User? user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email.toString(), password: CurrentPassword);
    user.reauthenticateWithCredential(cred).then((value) {
      // print("ok");
      if (NewPassword == RepeatPassword) {
        user.updatePassword(NewPassword).then((value) {
          print("Successfully changed Password");
          setState(() {
            loding = false;
          });
          Alert(
                  context: this.context,
                  title: "Success",
                  desc: "Successfully changed Password")
              .show();
        }).catchError((error) {
          print("Password can't be changed" + error.toString());
        });
      } else {
        setState(() {
          loding = false;
        });
        Alert(
                context: this.context,
                title: "invalid-password",
                desc: "Repeting the password is incorrect")
            .show();
      }
    }).catchError((e) {
      // print(e);
      setState(() {
        loding = false;
      });
      Alert(
              context: this.context,
              title: "wrong Current password",
              desc:
                  "The password is invalid or the user does not have a password")
          .show();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
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
                    children: [
                      const Text(
                        "تغییر کلمه عبور",
                        style: TextStyle(
                            fontFamily: 'Vazir',
                            package: 'persian_fonts',
                            color: Color.fromARGB(237, 255, 255, 255),
                            fontSize: 28,
                            fontWeight: FontWeight.w700),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(ProfilePage());
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Color.fromARGB(237, 255, 255, 255),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  controller: _CurrentPasswordController,
                                  obscuringCharacter: "*",
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "کلمه عبور فعلی",
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
                              height: 20,
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
                                  controller: _NewPasswordController,
                                  obscuringCharacter: "*",
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "کلمه عبور جدید",
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
                              height: 20,
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
                                  controller: _RepeatPasswordController,
                                  obscuringCharacter: "*",
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                      hintText: "تکرار کلمه عبور جدید",
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
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.05,
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              decoration: const BoxDecoration(
                                  color: Color(0xFF497fff),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    loding = true;
                                  });
                                  _changePassword(NewPassword, RepeatPassword,
                                      CurrentPassword);
                                },
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Visibility(
                                        visible: loding ? false : true,
                                        child: const Text(
                                          "تایید",
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
                          ],
                        ),
                      )
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
