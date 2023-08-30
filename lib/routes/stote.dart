import 'package:flutter/material.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:shop/routes/Product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shop/routes/ProductView.dart';

import 'package:shop/routes/search_results.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int category_id;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category_id,
    required this.image,
    required this.price,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        category_id: json['category_id'],
        image: json['image'],
        price: double.parse(json['price']));
  }
}

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
    );
  }
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Future<List<Categories>> _fetchCategories() async {
    final response = await http
        .get(Uri.parse("https://api.abolfazlabasi.ir/api/categories"));
    if (response.statusCode == 200) {
      return List<Categories>.from(json
          .decode(response.body)
          .map((x) => Categories.fromJson(x))
          .toList());
    } else {
      throw Exception("Faild to load products");
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final response =
        await http.get(Uri.parse("https://api.abolfazlabasi.ir/api/products"));
    if (response.statusCode == 200) {
      return List<Product>.from(
          json.decode(response.body).map((x) => Product.fromJson(x)).toList());
    } else {
      throw Exception("Faild to load products");
    }
  }

  static const List<String> sampleImages = [
    "https://dkstatics-public.digikala.com/digikala-products/ec9a962187e1f82cc47e7a148ef99ec1c6fd024d_1656423336.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/quality,q_90",
    "https://dkstatics-public.digikala.com/digikala-products/1b95a4ca2d5643f2b03f3721adef4cede444d3c5_1656406812.jpg?x-oss-process=image/resize,m_lfit,h_800,w_800/quality,q_90",
    // "https://images.unsplash.com/photo-1542840410-3092f99611a3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
  ];
  int _current = 0;
  List<String> _Images = [
    'https://dkstatics-public.digikala.com/digikala-adservice-banners/20321c2bef93aac3382cb56100076687d7d8756b_1676880049.jpg?x-oss-process=image/quality,q_95',
    'https://dkstatics-public.digikala.com/digikala-adservice-banners/7d0c29a23b5724541d3de048c991d5670f331882_1676880284.jpg?x-oss-process=image/quality,q_95',
    'https://dkstatics-public.digikala.com/digikala-adservice-banners/8b66bedc236e8665a131f48c52c26cfd8115a859_1676370686.jpg?x-oss-process=image/quality,q_95',
    // 'https://placeimg.com/640/480/any',
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 340,
                height: 50,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color.fromRGBO(206, 212, 223, 1)),
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                    onTap: () {
                      Get.to(SearchResultsPage());
                    },
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                        hintText: "جستجو",
                        hintStyle: const TextStyle(
                            fontFamily: 'Vazir',
                            package: 'persian_fonts',
                            color: Color.fromARGB(255, 71, 71, 113),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        prefixIcon: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.search)),
                        border: InputBorder.none)),
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle_rounded,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          CarouselSlider(
            items: _Images.map((image) {
              return Container(
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              );
            }).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _Images.map((image) {
              int index = _Images.indexOf(image);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 10.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Color.fromRGBO(0, 0, 1, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4)),
              );
            }).toList(),
          ),
          FutureBuilder(
            future: _fetchCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Categories> categori = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5,
                      mainAxisExtent: 55,
                      mainAxisSpacing: 5),
                  itemCount: categori.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final categories = categori[index];
                    return InkWell(
                      onTap: () {
                        Get.to(ProductPage(category_id: categories.id));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 45,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 124, 22, 197),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: Center(
                                child: Text(
                              categories.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Center(
                    // child: CircularProgressIndicator(),
                    );
              }
            },
          ),
          FutureBuilder(
            future: _fetchProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> Products = snapshot.data!;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: Products.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final product = Products[index];
                    return InkWell(
                      onTap: () {
                        Get.to(ProductView(product_id: product.id));
                      },
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Image.network(
                                  "https://api.abolfazlabasi.ir/storage/app/${product.image}")),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              package: 'persian_fonts',
                            ),
                          ),
                          Text(
                            '${product.price} \$',
                            style: const TextStyle(
                              fontFamily: 'Vazir',
                              package: 'persian_fonts',
                            ),
                          ),
                        ],
                      )),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ]),
      ]),
    );
  }
}
