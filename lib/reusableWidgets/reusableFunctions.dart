
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


Future<String> getUserPoints() async {
  DocumentReference userPoints =
  FirebaseFirestore.instance.collection('users').doc(currentUser);
  String points = "";

  try {
    DocumentSnapshot documentSnapshot = await userPoints.get();
    if (documentSnapshot.exists) {
      points = documentSnapshot.get('points').toString();
      return points;
    } else {
      return 'No data';
    }
  } catch (error) {
    return 'Error: $error';
  }
}

Future<String> getUserDiscountID() async {
  DocumentReference userPoints =
  FirebaseFirestore.instance.collection('users').doc(currentUser);
  String discountID = "";

  try {
    DocumentSnapshot documentSnapshot = await userPoints.get();
    if (documentSnapshot.exists) {
      discountID = documentSnapshot.get('discountID').toString();
      return discountID;
    } else {
      return 'No data';
    }
  } catch (error) {
    return 'Error: $error';
  }
}

void deleteSpecificDiscount(String discountID) async {
  DocumentReference userRef =
  FirebaseFirestore.instance.collection('users').doc(currentUser);

  DocumentReference discountRef =
  FirebaseFirestore.instance.collection('users').doc(currentUser).collection('discounts').doc(discountID);

  userRef.update({'discountID': ""});
  discountRef.delete();
}

Future<String> getSpecificDiscount(String discountID) async {
  DocumentReference userPoints =
  FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('discounts')
      .doc(discountID);
  String discountAmount = "";

  try {
    DocumentSnapshot documentSnapshot = await userPoints.get();
    if (documentSnapshot.exists) {
      discountAmount = documentSnapshot.get('discount').toString();
      return discountAmount;
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

Future<List<Map<String, dynamic>>> getAllDiscounts() async {
  CollectionReference discountCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('discounts');

  try {
    QuerySnapshot querySnapshot = await discountCollection.get();
    List<Map<String, dynamic>> discountList = [];

    for (var doc in querySnapshot.docs) {
      discountList.add({
        'discount': doc['discount'],
        'expiredAt': doc['expiredAt'],
        'deliverymethod': doc['deliverymethod'],
        'imageURL': doc['imageURL'],
        'id': doc.id,
      });
    }

    return discountList;
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
      .doc(uniqueID.toString());

  List<Map<String, dynamic>> orderHistory = cartItems.map((item) => {
    'name': item.name,
    'quantity': item.quantity,
    'price': item.price,
    'total': item.total,
    'imageURL': item.imageURL,
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

Future<void> createPointHistory(double total, int uniqueID) async {
  final pointCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('points')
      .doc(DateTime.now().toString());

  double points = 0;

  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  await userRef.get().then((value) {
    String currentRank = value.get('rank');

    if (currentRank == 'Beginner') {
      points = total * 1;
    } else if (currentRank == 'Intermediate') {
      points = total * 1.5;
    } else if (currentRank == 'Advanced') {
      points = total * 2;
    } else if (currentRank == 'Expert') {
      points = total * 3;
    }
  });

  //THIS POINT SYSTEM CURRENTLY DOES NOT AWARD PLAYER EXCESS POINTS REGARDLESS OF THE RANK UP
  //FUTURE NOTE: MAYBE ADD A FUNCTION TO AWARD EXCESS POINTS TO THE USER
  updateUserPoints(points);
  updateRank(points);


  pointCollectionRef.set({
    'id': uniqueID,
    'createdAt': DateTime.now().toString(),
    'points': points,
    'type' : 'Income',
  });
}

void updateUserPoints(double points) {
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  userRef.get().then((value) {
    double currentPoints = value.get('points');
    double newPoints = currentPoints + points;
    userRef.update({'points': newPoints});
  });
}

void resetDiscountID() {
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  userRef.get().then((value) {

    userRef.update({'discountID': ""});
  });
}

void updateUserDiscount(String discountID) {
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  userRef.get().then((value) {
    userRef.update({'discountID': discountID});
  });
}

Future<void> updateRank(double points) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);

  try {
    final userSnapshot = await userRef.get();
    double pointstoNextRank = userSnapshot.get('pointstoNextRank');
    double newPointstoNextRank = pointstoNextRank - points;

    if (newPointstoNextRank <= 0) {
      await rankUpUser(userSnapshot, newPointstoNextRank.abs());
    } else {
      await userRef.update({'pointstoNextRank': newPointstoNextRank});
    }
  } catch (e) {
    print("Error updating rank: $e");
  }
}

Future<void> rankUpUser(DocumentSnapshot userSnapshot, double excessPoints) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  String currentRank = userSnapshot.get('rank');
  String newRank;
  double newPointstoNextRank;

  switch (currentRank) {
    case 'Beginner':
      newRank = 'Intermediate';
      newPointstoNextRank = 100;
      excessPoints = excessPoints * 1.5;
      break;
    case 'Intermediate':
      newRank = 'Advanced';
      newPointstoNextRank = 250;
      excessPoints = excessPoints * 2;
      break;
    case 'Advanced':
      newRank = 'Expert';
      newPointstoNextRank = 500;
      excessPoints = excessPoints * 3;
      break;
    default:
      return; // If rank is already 'Expert' or unrecognized, do nothing.
  }

  await userRef.update({'rank': newRank, 'pointstoNextRank': newPointstoNextRank});

  if (excessPoints > 0) {
    await updateRank(excessPoints);


  }
}

Future<List> returnAllPointHistory() async{
  final pointCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('points');

  try {
    final orderCollectionSnapshot = await pointCollectionRef.get();
    List pointList = [];
    orderCollectionSnapshot.docs.forEach((doc) {
      pointList.add((
      id: doc.get('id'),
      createdAt: doc.get('createdAt'),
      points: doc.get('points'),
      type: doc.get('type'),
      ));
    });


    return pointList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}


Future<List> returnAllOrderHistory() async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List pendingorderList = [];
    List completedorderList = [];

    List orderList = [];

    orderCollectionSnapshot.docs.forEach((doc) {
      final order = ((
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

      if (order.status == 'Pending') {
        pendingorderList.add(order);
      } else {
        completedorderList.add(order);
      }
    });


    //sort from latest to oldest
    pendingorderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));
    completedorderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));

    orderList = pendingorderList + completedorderList;
    return orderList.toList();
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

    //sort from latest to oldest
    orderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));

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
      if (doc.get('status') != 'Pending') {
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


  //sort from latest to oldest
    orderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));

    return orderList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

Future<List> returnTodayOrderHistory() async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List orderList = [];
    orderCollectionSnapshot.docs.forEach((doc) {


      if (doc.get('type') != 'Topup') {
        if (DateTime.parse(doc.get('desiredPickupTime')).day == DateTime.now().day) {
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
      }
    });

    orderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));

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
    userDetails['pointstoNextRank'] = value.get('pointstoNextRank').toString();
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

Future<int> getcheckinCounter() async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  int checkinCounter = 0;
  String lastCheckedIn = "";

  DocumentSnapshot value = await userDocumentRef.get();
  checkinCounter = value.get('checkinCounter');
  lastCheckedIn = value.get('lastcheckedinTime');

  DateTime lastCheckedInTime = DateTime.parse(lastCheckedIn);
  DateTime now = DateTime.now();

  //if last checked in is more than 1 day ago, reset the counter
  if (now.difference(lastCheckedInTime).inHours >= 48) {
    checkinCounter = 0;
    userDocumentRef.update({'checkinCounter': checkinCounter});
    return 0;
  }



  return checkinCounter;
}

Future<bool> getIsCheckin() async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  bool isCheckin = false;
  String lastCheckedIn = "";

  DocumentSnapshot value = await userDocumentRef.get();
  lastCheckedIn = value.get('lastcheckedinTime');

  DateTime lastCheckedInTime = DateTime.parse(lastCheckedIn);
  DateTime now = DateTime.now();

  //if the user has already checked in display another button
  if (now.difference(lastCheckedInTime).inHours < 48 && now.difference(lastCheckedInTime).inHours > 24) {
    isCheckin = true;
  }

  return isCheckin;
}

Future<double> incrementcheckinCounter() async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  double checkinCounter = 0;
  double currentPoints = 0;
  double pointsObtained = 0;
  String lastCheckedIn = "";

  DocumentSnapshot value = await userDocumentRef.get();
  checkinCounter = value.get('checkinCounter');
  currentPoints = value.get('points');


  checkinCounter++;

  if (checkinCounter == 1) {
    pointsObtained = 1;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 2) {
    pointsObtained = 1;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 3) {
    pointsObtained = 2;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 4) {
    pointsObtained = 4;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 5) {
    pointsObtained = 6;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 6) {
    pointsObtained = 10;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  } else if (checkinCounter == 7) {
    checkinCounter = 0;
    pointsObtained = 15;
    currentPoints = currentPoints + pointsObtained;
    lastCheckedIn = DateTime.now().toString();
  }
  userDocumentRef.update({'checkinCounter': checkinCounter});
  userDocumentRef.update({'points': currentPoints});
  userDocumentRef.update({'lastcheckedinTime': lastCheckedIn});

  return pointsObtained;
}

void createDiscount(String points, String discount, DateTime validuntil, String deliverymethod, String imageURL) {
  final discountCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('discounts');

  final userCollectionRef = FirebaseFirestore.instance
    .collection('users')
    .doc(currentUser);

  //deduct points
  userCollectionRef.get().then((value) {
    int userPoints = value.get('points');
    userPoints = userPoints - int.parse(points);
    userCollectionRef.update({'points': userPoints});
  });


  //add discount voucher
  discountCollectionRef.add({
    'discount': discount,
    'expiredAt': validuntil,
    'deliverymethod': deliverymethod,
    'imageURL': imageURL,
  });
}

void createReview(List<dynamic> orderHistory, int id) {

  for (var history in orderHistory) {
    final reviewCollectionRef = FirebaseFirestore.instance
        .collection('admin')
        .doc('reviews')
        .collection(history['name']);

    final menuCollectionRef = FirebaseFirestore.instance
        .collection('menu');

    menuCollectionRef.get().then((value) {
      for (var doc in value.docs) {
        if (doc.get('name') == history['name']) {
          double currentRating = doc.get('totalRating');
          int currentRatingCount = doc.get('totalUsersRating');
          currentRatingCount = currentRatingCount + 1;
          currentRating = currentRating + history['rating'];
          double newRating = currentRating / currentRatingCount;
          menuCollectionRef
              .doc(doc.id)
              .update({
            'rating': newRating,
            'totalRating': currentRating,
            'totalUsersRating': currentRatingCount,
          });
        }
      }
    });

    reviewCollectionRef.doc(id.toString()).set({
      'id': id,
      'userID': currentUser,
      'comment': history['comment'],
      'rating': history['rating'],
      'quantity': history['quantity'],
    });

    updateHistoryStatus(id, "Completed and Reviewed");
  }
}

void updateHistoryStatus(int id, String status) {
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history')
      .doc(id.toString());

  orderCollectionRef.update({'status': status});
}

//used to test database
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

//used to test database
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

String HourFormatter(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedDate = DateFormat('hh:mm a').format(dateTime);
  return formattedDate;
}

String DayMonthYearFormatter(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
  return formattedDate;
}

String TimestampToStringFormatter(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
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

