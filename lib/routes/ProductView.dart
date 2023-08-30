import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductView extends StatefulWidget {
  final int product_id;
  const ProductView({super.key, required this.product_id});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  Future _fetchProducts() async {
    var id = widget.product_id;
    final response =
        await http.get(Uri.parse("https://yoursite.com/api/products/$id"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Faild to load products");
    }
  }

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Icon(Icons.arrow_back),
                        Text("Shop"),
                        Icon(Icons.shopping_bag_outlined)
                      ],
                    ),
                    Image.network(
                        "https://yoursite.com/storage/app/${snapshot.data['image']}"),
                    Text(
                      snapshot.data['name'],
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                          fontFamily: 'Vazir',
                          package: 'persian_fonts',
                          fontSize: 17),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            "${snapshot.data['price']} \$",
                            style: const TextStyle(
                                fontFamily: 'Vazir',
                                package: 'persian_fonts',
                                fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Text(
                        snapshot.data['description'],
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: 'Vazir',
                          package: 'persian_fonts',
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: ButtonBar(children: [
        Row(
          children: [
            if (count == 0)
              GestureDetector(
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  width: 190,
                  height: 60,
                  child: const Center(
                      child: Text(
                    "افزودن در سبد خرید",
                    style: TextStyle(
                        fontFamily: 'Vazir',
                        color: Colors.white,
                        package: 'persian_fonts',
                        fontSize: 17),
                  )),
                ),
              ),
            if (count >= 1)
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 214, 215, 223),
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                width: 190,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (count > 1)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              count--;
                            });
                          },
                          child: Icon(
                            Icons.remove,
                            size: 25,
                            color: Colors.red,
                          ),
                        ),
                      if (count == 1)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              count--;
                            });
                          },
                          child: Icon(
                            Icons.delete_forever,
                            size: 25,
                            color: Colors.red,
                          ),
                        ),
                      Text(
                        count.toString(),
                        style: TextStyle(color: Colors.red),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            count++;
                          });
                        },
                        child: Icon(
                          Icons.add,
                          size: 25,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        )
      ]),
    );
  }
}
