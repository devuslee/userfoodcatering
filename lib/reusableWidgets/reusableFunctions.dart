
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userfoodcatering/class/menuClass.dart';

final currentUser = FirebaseAuth.instance.currentUser!.uid;
final FirebaseStorage _storage = FirebaseStorage.instance;

Future<String> getUserBalance() async {
  DocumentReference userBalance =
  FirebaseFirestore.instance.collection('users').doc(currentUser);
  String balance = "";

  try {
    DocumentSnapshot documentSnapshot = await userBalance.get();
    if (documentSnapshot.exists) {
      balance = documentSnapshot.get('balance').toString();
      balance = "RM$balance";
      return balance;
    } else {
      return 'No data';
    }
  } catch (error) {
    return 'Error: $error';
  }
}


Future<String> getUserPoints() async {
  DocumentReference userPoints =
  FirebaseFirestore.instance.collection('users').doc(currentUser);
  String points = "";

  try {
    DocumentSnapshot documentSnapshot = await userPoints.get();
    if (documentSnapshot.exists) {
      points = documentSnapshot.get('points').toString();
      points = "$points pts";
      return points;
    } else {
      return 'No data';
    }
  } catch (error) {
    return 'Error: $error';
  }
}

Future<String> getUserRank() async{
  DocumentReference userRank =
  FirebaseFirestore.instance.collection('users').doc(currentUser);

  try {
    DocumentSnapshot documentSnapshot = await userRank.get();
    if (documentSnapshot.exists) {
      return documentSnapshot.get('rank').toString();
    } else {
      return 'No data';
    }
  } catch (error) {
    return 'Error: $error';
  }
}

Future<List<MenuClass>> getMenuData() async {
  CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');
  FirebaseStorage _storage = FirebaseStorage.instance;

  try {
    QuerySnapshot querySnapshot = await menuCollection.get();
    List<MenuClass> menuList = [];



    await Future.wait(querySnapshot.docs.map((doc) async {
      String imageURL = doc['imageURL'].toString();
      String downloadURL = await _storage.ref('menu/$imageURL.jpeg').getDownloadURL();
      double price = doc['price'].toDouble();

      menuList.add(MenuClass(
        name: doc['name'].toString(),
        description: doc['description'].toString(),
        imageURL: downloadURL,
        price: price,
        rating: doc['rating'].toString(),
      ));
    }));

    return menuList;
  } catch (error) {
    print('Error fetching menu data: $error');
    return [];
  }
}


void addToCart(String foodName, double price, int quantity, double total, String imageURL) async {

  final foodDocumentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart')
      .doc(foodName);

  await foodDocumentRef.set({
    'name': foodName,
    'price': price,
    'quantity': quantity,
    'total': total,
    'imageURL': imageURL,
  });
}


Future<int> getFoodQuantity(String foodName) async {
  final foodDocumentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('cart')
      .doc(foodName);

  try {
    final foodDocumentSnapshot = await foodDocumentRef.get();
    if (foodDocumentSnapshot.exists) {
      return foodDocumentSnapshot.get('quantity');
    } else {
      return 1;
    }
  } catch (error) {
    return 1;
  }
}

Future<int> getCartQuantity() async {
  final cartCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart');

  int counter = 0;

  try {
    final cartCollectionSnapshot = await cartCollectionRef.get();
    cartCollectionSnapshot.docs.forEach((doc) {
      counter++;
    });
    return counter;
  } catch (error) {
    print('Error fetching cart quantity: $error');
    return 0;
  }
}

Future<List> getUserCart() async{
  final cartCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart');

  try {
    final cartCollectionSnapshot = await cartCollectionRef.get();
    List cartList = [];
    cartCollectionSnapshot.docs.forEach((doc) {
      cartList.add((
      name: doc.get('name'),
      price: doc.get('price'),
      quantity: doc.get('quantity'),
      total: doc.get('total'),
      imageURL: doc.get('imageURL'),
      ));
    });
    return cartList;
  } catch (error) {
    print('Error fetching cart data: $error');
    return [];
  }
}


Future<List<MenuClass>> getSpecificMenuData(String foodname) async {
  CollectionReference menuCollection = FirebaseFirestore.instance.collection('menu');
  FirebaseStorage _storage = FirebaseStorage.instance;

  try {
    QuerySnapshot querySnapshot = await menuCollection.get();
    List<MenuClass> menuList = [];

    await Future.wait(querySnapshot.docs.map((doc) async {
      String imageURL = doc['imageURL'].toString();
      String downloadURL = await _storage.ref('menu/$imageURL.jpeg').getDownloadURL();
      double price = doc['price'].toDouble();

      if (doc['name'].toString().toLowerCase().contains(foodname.toLowerCase())) {
      menuList.add(MenuClass(
        name: doc['name'].toString(),
        description: doc['description'].toString(),
        imageURL: downloadURL,
        price: price,
        rating: doc['rating'].toString(),
        ));
      }}
    ));

    return menuList;
  } catch (error) {
    print('Error fetching menu data: $error');
    return [];
  }
}

void deleteSpecificCart(String foodname) async {
  final cartCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart')
      .doc(foodname);

  try {
    final cartCollectionSnapshot = await cartCollectionRef.get();
    cartCollectionSnapshot.reference.delete();
  } catch (error) {
    print('Error fetching cart data: $error');
  }
}

void deleteWholeCart() async {
  final cartCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart');

  try {
    final cartCollectionSnapshot = await cartCollectionRef.get();
    cartCollectionSnapshot.docs.forEach((doc) {
      doc.reference.delete();
    });
  } catch (error) {
    print('Error fetching cart data: $error');
  }
}

void sendOrder(List cartItems, String specialRemarks, String desiredPickupTime, double total) {
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('admin')
      .doc('orders')
      .collection(DateTime.timestamp().toString());

  cartItems.forEach((item) async {
    await orderCollectionRef.doc(item.name).set({
      'name': item.name,
      'price': item.price,
      'quantity': item.quantity,
      'total': item.total,
      'imageURL': item.imageURL,
      'status': 'Pending',
      'customer': currentUser,
      'createdAt': DateTime.now().toString(),
      'specialRemarks': specialRemarks,
      'desiredPickupTime': desiredPickupTime,
      'total': total,
    });
  });
}

void createOrderHistory(List cartItems, String specialRemarks, String desiredPickupTime, double total) {
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history')
      .doc(DateTime.now().toString());

  List<Map<String, dynamic>> orderHistory = cartItems.map((item) => {
    'name': item.name,
    'quantity': item.quantity,
  }).toList();

  orderCollectionRef.set({
    'orderHistory': orderHistory,
    'status': 'Pending',
    'createdAt': DateTime.now().toString(),
    'specialRemarks': specialRemarks,
    'desiredPickupTime': desiredPickupTime,
    'total': total,
  });

}


Future<List> returnAllOrderHistory() async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List orderList = [];
    orderCollectionSnapshot.docs.forEach((doc) {
      orderList.add((
        orderHistory: doc.get('orderHistory'),
        status: doc.get('status'),
        createdAt: doc.get('createdAt'),
        specialRemarks: doc.get('specialRemarks'),
        desiredPickupTime: doc.get('desiredPickupTime'),
        total: doc.get('total'),
      ));
    });

    print(orderList);

    return orderList;
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }

}
