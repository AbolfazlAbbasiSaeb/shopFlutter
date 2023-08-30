import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:persian_fonts/persian_fonts.dart';
import 'package:get/get.dart';
import 'package:shop/routes/ProductView.dart';

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

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  var search;
  final _Value = TextEditingController();
  String get value => _Value.text.trim();
  Future<List<Product>> _fetchProducts() async {
    if (value == "") {
      search = "Slkjlkj243*-+@#455345";
    } else {
      search = value;
    }
    final response =
        await http.get(Uri.parse("https://yoursite.com/api/product?q=$search"));
    if (response.statusCode == 200) {
      return List<Product>.from(
          json.decode(response.body).map((x) => Product.fromJson(x)).toList());
    } else {
      throw Exception("Faild to load products");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 50, 20, 20),
          child: TextFormField(
            onChanged: (value) {
              setState(() {});
            },
            controller: _Value,
            autofocus: true,
            decoration: InputDecoration(
                hintText: 'Search',
                enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(0, 0, 0, 0), width: 1),
                    borderRadius: BorderRadius.circular(0)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                        color: Color.fromARGB(0, 0, 0, 0), width: 1),
                    borderRadius: BorderRadius.circular(0)),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                ),
                suffixIcon: const Icon(
                  Icons.chevron_right_outlined,
                  color: Color(0xFF757575),
                  size: 22,
                )),
          ),
        ),
        SizedBox(
          height: 150,
          child: Expanded(
            child: FutureBuilder(
              future: _fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product> Products = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: Products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = Products[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(ProductView(product_id: product.id));
                          },
                          child: Row(
                            children: [
                              Text(
                                product.name,
                                style: PersianFonts.Shabnam,
                              ),
                              Image.network(
                                  "https://yoursite.com/storage/app/${product.image}",
                                  width: 100),
                              // Text('${product.price} \$'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text(
                    "دیگر کالا های جستجوی شما",
                    style: TextStyle(
                        fontFamily: 'Vazir',
                        package: 'persian_fonts',
                        fontSize: 15),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.more_horiz_sharp,
                    size: 40,
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          // height: 150,
          child: Expanded(
            child: FutureBuilder(
              future: _fetchProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Product> Products = snapshot.data!;
                  return ListView.builder(
                    reverse: true,
                    itemCount: Products.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final product = Products[index];
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: InkWell(
                          onTap: () {
                            Get.to(ProductView(product_id: product.id));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(
                                    fontFamily: 'Vazir',
                                    package: 'persian_fonts'),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Icon(Icons.search)
                              // Text('${product.price} \$'),
                            ],
                          ),
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
          ),
        ),
      ],
    ));
  }
}
