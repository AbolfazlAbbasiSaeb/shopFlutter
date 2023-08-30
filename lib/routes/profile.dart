import 'dart:io';

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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  File? image;
  bool _isUploading = false;
  LogoProfile() {
    var photoURL = FirebaseAuth.instance.currentUser?.photoURL;
    // return image != null ? FileImage(image!) : AssetImage("assets/avatar.png");
    if (photoURL != null) {
      return NetworkImage(photoURL);
    } else if (image != null) {
      return FileImage(image!);
    } else {
      return AssetImage("assets/avatar.png");
    }
  }

  Future<String?> _getDisplayName() async {
    User? user = await FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      return user.displayName;
    } else if (user == null) {
      Get.to(const LoginPage());
    } else {
      await Future.delayed(const Duration(seconds: 2));
      user = await FirebaseAuth.instance.currentUser;
      return user?.displayName;
    }
  }

  Future UploadFile() async {
    if (image == null) return;
    final fileName = basename(image!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(image!);
      var photoUrl = await ref.getDownloadURL();
      await FirebaseAuth.instance.currentUser?.updatePhotoURL(photoUrl);
      setState(() {
        _isUploading = false;
      });
    } catch (e) {
      print("Error $e");
    }
  }

  Future pickImage() async {
    try {
      setState(() {
        _isUploading = true;
      });
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imagePath = File(image.path);
      setState(() {
        this.image = imagePath;
        UploadFile();
      });
    } catch (e) {}
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDisplayName(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
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
                          children: const [
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "پروفایل",
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
                        Container(
                          height: 300,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 60,
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  image: DecorationImage(
                                      image: LogoProfile(), fit: BoxFit.cover),
                                ),
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: Image.asset(
                                          "assets/add.png",
                                          width: 40,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text(snapshot.data,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23.0)),
                              ),
                              if (_isUploading == true)
                                const CircularProgressIndicator(
                                    color: Colors.green),
                            ],
                          ),
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
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(PasswordPage());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 15,
                                          left: 0,
                                          right: 0,
                                          top: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.deepPurple[50]),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blue,
                                                size: 30.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "کلمه عبور",
                                                  style: TextStyle(
                                                      fontFamily: 'Vazir',
                                                      package: 'persian_fonts',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors
                                                            .deepPurple[100]),
                                                    width: 60,
                                                    height: 90,
                                                    child: const Icon(
                                                      Icons.lock_open,
                                                      color: Colors.blue,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.to(EmailPage()),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 15,
                                          left: 0,
                                          right: 0,
                                          top: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.deepPurple[50]),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blue,
                                                size: 30.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "آدرس ایمیل",
                                                  style: TextStyle(
                                                      fontFamily: 'Vazir',
                                                      package: 'persian_fonts',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors
                                                            .deepPurple[100]),
                                                    width: 60,
                                                    height: 90,
                                                    child: const Icon(
                                                      Icons.email_outlined,
                                                      color: Colors.blue,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 0, right: 0, top: 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.deepPurple[50]),
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.blue,
                                              size: 30.0,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "پشتیبانی",
                                                style: TextStyle(
                                                    fontFamily: 'Vazir',
                                                    package: 'persian_fonts',
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors
                                                          .deepPurple[100]),
                                                  width: 60,
                                                  height: 90,
                                                  child: const Icon(
                                                    Icons.contact_support,
                                                    color: Colors.blue,
                                                    size: 30.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        FirebaseAuth.instance.signOut();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 0, left: 0, right: 0, top: 0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.deepPurple[50]),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height: 80,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.blue,
                                                size: 30.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "خروج",
                                                  style: TextStyle(
                                                      fontFamily: 'Vazir',
                                                      package: 'persian_fonts',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors
                                                            .deepPurple[100]),
                                                    width: 60,
                                                    height: 90,
                                                    child: const Icon(
                                                      Icons.logout,
                                                      color: Colors.blue,
                                                      size: 30.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
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
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
