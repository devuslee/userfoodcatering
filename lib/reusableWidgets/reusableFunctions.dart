
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:intl/intl.dart';
import 'dart:math';

final currentUser = FirebaseAuth.instance.currentUser!.uid;
final FirebaseStorage _storage = FirebaseStorage.instance;

// Future<String> getUserBalance() async {
//   DocumentReference userBalance =
//   FirebaseFirestore.instance.collection('users').doc(currentUser);
//   String balance = "";
//
//   try {
//     DocumentSnapshot documentSnapshot = await userBalance.get();
//     if (documentSnapshot.exists) {
//       balance = documentSnapshot.get('balance').toString();
//       balance = "RM $balance";
//       return balance;
//     } else {
//       return 'No data';
//     }
//   } catch (error) {
//     return 'Error: $error';
//   }
// }


// Future<String> getUserPoints() async {
//   DocumentReference userPoints =
//   FirebaseFirestore.instance.collection('users').doc(currentUser);
//   String points = "";
//
//   try {
//     DocumentSnapshot documentSnapshot = await userPoints.get();
//     if (documentSnapshot.exists) {
//       points = documentSnapshot.get('points').toString();
//       points = "$points pts";
//       return points;
//     } else {
//       return 'No data';
//     }
//   } catch (error) {
//     return 'Error: $error';
//   }
// }

// Future<String> getUserRank() async{
//   DocumentReference userRank =
//   FirebaseFirestore.instance.collection('users').doc(currentUser);
//
//   try {
//     DocumentSnapshot documentSnapshot = await userRank.get();
//     if (documentSnapshot.exists) {
//       return documentSnapshot.get('rank').toString();
//     } else {
//       return 'No data';
//     }
//   } catch (error) {
//     return 'Error: $error';
//   }
// }

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
        rating: doc['rating'].toDouble(),
        category: doc['category'].toString(),
      ));
    }));


    return menuList;
  } catch (error) {
    print('Error fetching menu data: $error');
    return [];
  }
}

Future<List> getAllCategories() async {
  CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');

  try {
    QuerySnapshot querySnapshot = await categoryCollection.get();
    List menuList = [];

    await Future.wait(querySnapshot.docs.map((doc) async {
      menuList.add(doc['type']);
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
        rating: doc['rating'].toDouble(),
        category: doc['category'].toString(),
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

void sendOrder(List cartItems, String specialRemarks, String desiredPickupTime, double total, int uniqueID, String paymentMethod) {
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('admin')
      .doc('orders')
      .collection(DateTime.now().toString());

  cartItems.forEach((item) async {
    await orderCollectionRef.doc(item.name).set({
      'id': uniqueID,
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
      'paymentMethod': paymentMethod,
    });
  });
}

void createOrderHistory(List cartItems, String specialRemarks, String desiredPickupTime, double total, int uniqueID, String paymentMethod, String type) {
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
    'id': uniqueID,
    'orderHistory': orderHistory,
    'status': 'Pending',
    'createdAt': DateTime.now().toString(),
    'specialRemarks': specialRemarks,
    'desiredPickupTime': desiredPickupTime,
    'total': total,
    'paymentMethod': paymentMethod,
    'type': type,
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
        id: doc.get('id'),
        orderHistory: doc.get('orderHistory'),
        status: doc.get('status'),
        createdAt: doc.get('createdAt'),
        specialRemarks: doc.get('specialRemarks'),
        desiredPickupTime: doc.get('desiredPickupTime'),
        total: doc.get('total'),
        paymentMethod: doc.get('paymentMethod'),
        type: doc.get('type'),
      ));
    });


    return orderList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

Future<List> returnActiveOrderHistory() async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List orderList = [];
    orderCollectionSnapshot.docs.forEach((doc) {
      if (doc.get('status') == 'Pending') {
        orderList.add((
          id: doc.get('id'),
          orderHistory: doc.get('orderHistory'),
          status: doc.get('status'),
          createdAt: doc.get('createdAt'),
          specialRemarks: doc.get('specialRemarks'),
          desiredPickupTime: doc.get('desiredPickupTime'),
          total: doc.get('total'),
          paymentMethod: doc.get('paymentMethod'),
          type: doc.get('type'),
        ));
      }
    });


    return orderList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

Future<List> returnPastOrderHistory() async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List orderList = [];
    orderCollectionSnapshot.docs.forEach((doc) {
      if (doc.get('status') == 'Completed') {
        orderList.add((
        id: doc.get('id'),
        orderHistory: doc.get('orderHistory'),
        status: doc.get('status'),
        createdAt: doc.get('createdAt'),
        specialRemarks: doc.get('specialRemarks'),
        desiredPickupTime: doc.get('desiredPickupTime'),
        total: doc.get('total'),
        paymentMethod: doc.get('paymentMethod'),
        type: doc.get('type'),
        ));
      }
    });

    return orderList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

void TopupUserWallet(double amount) {
  final userDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser);

  userDocumentRef.get().then((value) {
    double currentBalance = value.get('balance');
    double newBalance = currentBalance + amount;
    userDocumentRef.update({'balance': newBalance});
  });

  Random random = Random();
  int randomNumber = random.nextInt(1000000000) + 1;

  //creates income history
  createOrderHistory([], "", "", amount, randomNumber, "", "Topup");

}

void deductWalletBalance(double amount) {
  final userDocumentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser);

  userDocumentRef.get().then((value) {
    double currentBalance = value.get('balance');
    double newBalance = currentBalance - amount;
    userDocumentRef.update({'balance': newBalance});
  });
}

Future<Map<String, String>> getUserDetails() async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);

  Map<String, String> userDetails = {};

  try {
    DocumentSnapshot value = await userDocumentRef.get();
    userDetails['balance'] = value.get('balance').toString();
    userDetails['username'] = value.get('username');
    userDetails['email'] = value.get('email');
    userDetails['userid'] = value.get('userid');
    userDetails['rank'] = value.get('rank');
    userDetails['points'] = value.get('points').toString();
    userDetails['profileImage'] = value.get('profileImage');
    String tempProfile = value.get('profileImage');
    String downloadURL = await _storage.ref('users/$tempProfile.jpeg').getDownloadURL();
    userDetails['profileURL'] = downloadURL;
  } catch (e) {
    print('Error fetching user details: $e');
  }

  return userDetails;
}

Future<void> updateProfile(String username, String profileImage) async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);

  try {
    userDocumentRef.update({
      'username': username,
      'profileImage': profileImage,
    });
  } catch (e) {
    print('Error updating profile: $e');
  }
}

void TempCreateMenu() {
  final menuRef = FirebaseFirestore.instance.collection('menu').doc('Menu').collection('food_1');

  menuRef.add({
    'name': 'Nasi Lemak',
    'description': 'Nasi lemak is a Malay fragrant rice dish cooked in coconut milk and pandan leaf. It is commonly found in Malaysia, where it is considered the national dish.',
    'price': 5.00,
    'rating': 4.5,
    'imageURL': 'food_1',
    'category': 'Vegetables'
  });
}

void TempCreateCategory() {
  final categoryRef = FirebaseFirestore.instance.collection('admin').doc('categories');

  categoryRef.set({
    'categories': ['Vegetables', 'Meat', 'Seafood', 'Dessert', 'Drinks']
  });

}




String TimestampFormatter(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedDate = DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
  return formattedDate;
}


String DaysFromTimeStamp(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  DateTime now = DateTime.now();
  int difference = now.difference(dateTime).inDays;

  if (difference == 0) {
    return 'Today';
  } else if (difference == 1) {
    return 'Yesterday';
  } else if (difference > 30) {
    return ((difference/30).round()).toString() + ' months ago';
  } else {
    return difference.toString() + ' days ago';
  }

}

String PickupTimestampFormatter(String timestamp, String desiredPickupTime) {
  DateTime dateTime = DateTime.parse(timestamp);
  String strippedTime = desiredPickupTime.split(' ')[0];
  int strippedHour = int.parse(strippedTime.split(':')[0]);
  int strippedMinute =int.parse(strippedTime.split(':')[1]);
  dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day + 1, strippedHour, strippedMinute);
  String formattedDate = DateFormat('dd MMMM yyyy HH:mm').format(dateTime);
  return formattedDate;
}

