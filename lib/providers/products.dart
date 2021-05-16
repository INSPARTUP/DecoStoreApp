import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

//import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //     id: 'p2',
    //     title: 'Trousers',
    //     description: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Trousers-colourisolated.jpg/255px-Trousers-colourisolated.jpg'),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    var url = Uri.parse('https://productsapi1.herokuapp.com/api/produits');

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> productsJsonData = json.decode(response.body);
      _items = productsJsonData.map((e) => Product.fromJson(e)).toList();
    } else {
      _items = [];
    }
  }

  static Future<Product> fetchProduct(String id) async {
    var url = Uri.parse('https://productsapi1.herokuapp.com/api/produits$id');
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.body);
      dynamic jsonData = json.decode(response.body);
      return Product.fromJson(jsonData);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Server Error');
    }
  }

  Future<void> addProduct(Product product) async {
    //async means that code of the function or methode (addProduct) will return automticaly a Future because all the code is wrapped in the Future

    var url = Uri.parse('https://productsapi1.herokuapp.com/api/produits');

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(product.toJson())

          /*     json.encode({
          ////with json.encode we can convert this map into JSON format
          'nom': product.nom,
          'type': product.type,
          'prix': product.prix,
          'description': product.description,
          'quantite': product.quantite,
          'imageUrl': product.imageurl,
        }),
*/

          );
      // had l code yakhdam 7ata tawsalna response m database (post tkamal khadmatha)
      print(json.decode(response
          .body)); //with json.decode we can convert this from JSON into some data we can work in Dart (Map)
      final newProduct = Product(
        nom: product.nom,
        description: product.description,
        id: json.decode(response.body)['id'],
        //use the ID generated by firebase
        imageurl: product.imageurl,
        prix: product.prix,
        type: product.type,
        quantite: product.quantite,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      var url =
          Uri.parse('https://productsapi1.herokuapp.com/api/produits/$id');

      final response = await http.put(url,
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            'nom': newProduct.nom,
            'description': newProduct.description,
            'imageUrl': newProduct.imageurl,
            'prix': newProduct.prix,
            'quantite': newProduct.quantite,
            'type': newProduct.type,
          }));

      //darna await sama ki ykamal l code lilfoga ydir li rah lta7t sama ydir update f local memoire
      Fluttertoast.showToast(
          msg: json.decode(response.body)['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      print(json.decode(response.body)['message']);

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else
      print('...');
  }

  Future<void> deleteProduct(String id) async {
    var url = Uri.parse('https://productsapi1.herokuapp.com/api/produits/$id');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    Fluttertoast.showToast(
        msg: json.decode(response.body)['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }

    existingProduct = null;
  }
}
