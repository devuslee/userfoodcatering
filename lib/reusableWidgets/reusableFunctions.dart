import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:userfoodcatering/class/menuClass.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../screens/CalendarPage.dart';
import '../screens/LoginPage.dart';
import 'package:userfoodcatering/notification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

HfInference hfInference = HfInference('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');

String? currentUser = FirebaseAuth.instance.currentUser!.uid;

final FirebaseStorage _storage = FirebaseStorage.instance;
final _firebaseMessaging = FirebaseMessaging.instance;

// Future<void> sendNotification(String title, String body, String fcmToken) async {
//   final String serverKey = '831398945187';
//   final url = 'https://fcm.googleapis.com/fcm/send';
//
//   final headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'key=$serverKey',
//   };
//
//   final payload = {
//     'to': "e6_tACIaQWCxnmgSceWifj:APA91bFG92N06gwkaaYsuu-jOoihYkwUeTJgY_iEtkGDpOvUGbQqcbQaCxRa650f5uyjhG4g3av05UTwYuPkq6gTDmoH6cFURmmldbrVozSYuyxgDq3f5gfbwcg-4NtT3bbDlZhJhz4m", // The FCM token of the device to receive the notification
//     'notification': {
//       'title': title,
//       'body': body,
//       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//     },
//   };
//
//   final response = await http.post(
//     Uri.parse(url),
//     headers: headers,
//     body: json.encode(payload),
//   );
//
//   if (response.statusCode == 200) {
//     print('Notification sent successfully.');
//   } else {
//     print('Failed to send notification: ${response.body}');
//   }
// }

Future<void> sendNotification(String title, String body, String fcmToken) async {
  final url = 'https://fcm.googleapis.com/v1/projects/foodcatering-6bb02/messages:send';
  final accessToken = "ya29.c.c0ASRK0GYqNNqljZfiqbS6gOFwxXhWaiQFwAVaOBevjJJDWGzvYEr5VMOGlnTGEvaF-wxjUmMKcOUN3q2gbFzqKw12p-5GdbWDwDud3JLJ4TIC4P2zNWJXl61eCwCwR52LfRtVNrc_4qkK3fQQelwPl0zzLQcliVcp29tvKSPB5vc2OEYET-ZOHpyfHsoySDMNxzlvFCw5n_9Cz1YY9ncVIl6R4h-PWtBiHo_DKrJeX7vlduilUZR7Hu6U8VuWfuU_VRBYppkcaATdRPUzsJmVx1itzOERmiRjnOOBdMJhgpg9IVJeRaLdY7ny18X8Et5ld-C89kayvx_JUugCgtXeyu6hTi8RuFBkUBtHCurfFoWuYLrkc5I0xyuYtwT387KtOMyllr2gziiZBxb_y3vVfYvRamZoq56hpnF7-SJ0f3bnmpxmIwqt50jf9kdIXlMUpfRb8sO8zU05jk4qSjWJmO6m3VfqXM9UcVQepYdcvMUXsgob4nm2p1Rx79boO3kqVybxnt3lb5niRjdb6_6coiMoUfj8x86wcXVqwrX95W3U9VdFkYxOemisOnW46Iryk-mM2f5xzUlBa9uzXlpjzbMOQiv05pJRgY0so2gaZSgMBOUlWQSzimwvcjptVnvj7t-1kaX0qQXX10vvZxWhJ_g1s4M9uUWwd1wYuu1l0t2uqIS1yIisrusZ4FRlV6Sln88wRYhQYdUmU_01VRewxqO9t1tMmic7vb3yb3zJfVe-see-96wXbOrnteRqbjU6iduhYh3ogyo26277X5hhaVF9svbmVd0wn43i9u2oskMecV1qi7247VQQUFlyzRRZXJRiiz4Jw-J7kXus3Q1d6IxsWmvMkez6ib225qvhVtq4tUM-YywXe9be1inv_6mr2fOlWfpZ4R6wSO3zflJggfcqfJoq1hgR8Raram_xaOsxkmxdQWW97RgOlwg-Rx6SSoR1isM9bYQJb5g8M2MuYxizscR2yBtmR5qtxBBSQ20i6UhaB_XpFwo";

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $accessToken', // Use OAuth 2.0 token
  };

  final payload = {
    'message': {
      'token': "e6_tACIaQWCxnmgSceWifj:APA91bFG92N06gwkaaYsuu-jOoihYkwUeTJgY_iEtkGDpOvUGbQqcbQaCxRa650f5uyjhG4g3av05UTwYuPkq6gTDmoH6cFURmmldbrVozSYuyxgDq3f5gfbwcg-4NtT3bbDlZhJhz4m",
      'notification': {
        'title': title,
        'body': body,
      },
      'android': {
        'notification': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
    },
  };

  final response = await http.post(
    Uri.parse(url),
    headers: headers,
    body: json.encode(payload),
  );

  if (response.statusCode == 200) {
    print('Notification sent successfully.');
  } else {
    print('Failed to send notification: ${response.body}');
  }
}

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotification(tz.TZDateTime scheduledTime) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('your_channel_id', 'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false);

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'Scheduled Notification',
    'This is the scheduled notification body',
    scheduledTime,  // DateTime when the notification should be fired
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
    UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,  // Can use time to trigger daily or weekly notifications
  ).then((value) =>
    print('Notification scheduled successfully')
  );
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

Future<void> saveFCMtoken() async {
  await _firebaseMessaging.requestPermission();
  final fCMToken = await _firebaseMessaging.getToken();

  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  print('FCM Token: $fCMToken');
  userRef.update({'fcmToken': fCMToken});

  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
}


void getCurrentUserId() {
  currentUser = FirebaseAuth.instance.currentUser?.uid;
}


Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  final userRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  userRef.update({'fcmToken': ""});

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
  );
}



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


void addToCart(String foodName, num price, int quantity, num total, String imageURL) async {

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

Future<void> clearCart() async {
  final foodDocumentRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart')
      .get();

  foodDocumentRef.docs.forEach((doc) {
    doc.reference.delete();
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

Future<double> getCartTotal() async {
  final cartCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart');

  double? total = 0;

  try {
    final cartCollectionSnapshot = await cartCollectionRef.get();
    cartCollectionSnapshot.docs.forEach((doc) {
      total = doc.get('total') + total!;
    });
    return total!;
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
  print(desiredPickupTime.split(' ')[0]);

  final orderCollectionRef = FirebaseFirestore.instance
      .collection('admin')
      .doc('orders')
      .collection(desiredPickupTime.split(' ')[0].toString())
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
    'userID': currentUser,
    'orderHistory': orderHistory,
    'status': 'Pending',
    'createdAt': DateTime.now().toString(),
    'specialRemarks': specialRemarks,
    'desiredPickupTime': desiredPickupTime,
    'total': total,
    'paymentMethod': paymentMethod,
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
      .doc(uniqueID.toString());

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

Future<void> createReviewPointHistory(double total, int uniqueID) async {
  final pointCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('points')
      .doc(uniqueID.toString());

  double points = 0;

  points = total * 1;

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

    pointList.sort((a, b) => a.createdAt.compareTo(b.createdAt));


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
    pendingorderList.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    completedorderList.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    orderList = pendingorderList + completedorderList;
    return orderList.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

Future<List> returnAllFilteredOrderHistory(String selectedCategory) async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List expenseorderList = [];
    List refundorderList = [];
    List topuporderlist = [];

    List orderList = [];


    if (selectedCategory == 'All') {
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

        if (order.type == 'Expense') {
          expenseorderList.add(order);
        } else if (order.type == "Refund") {
          refundorderList.add(order);
        } else {
          topuporderlist.add(order);
        }
      });
    }

    if (selectedCategory == 'Refund') {
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

        if (order.type == 'Refund') {
          refundorderList.add(order);
        }
      });
    }

    if (selectedCategory == 'Topup') {
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

        if (order.type == 'Topup') {
          topuporderlist.add(order);
        }
      });
    }

    if (selectedCategory == 'Expense') {
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

        if (order.type == 'Expense') {
          expenseorderList.add(order);
        }
      });
    }


    //sort from latest to oldest
    expenseorderList.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    refundorderList.sort((b, a) => a.createdAt.compareTo(b.createdAt));
    topuporderlist.sort((b, a) => a.createdAt.compareTo(b.createdAt));

    orderList = expenseorderList + refundorderList + topuporderlist;
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

      if (doc.get('status') == 'Ready') {
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

    return orderList.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

void updateSpecificCart(String foodName, int quantity, double total) async {
  final foodDocumentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('cart')
      .doc(foodName);

  await foodDocumentRef.update({
    'quantity': quantity,
    'total': total,
  });
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
      if (doc.get('status') == 'Completed and Reviewed') {
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


  //sort from latest to oldest
    orderList.sort((a, b) => a.desiredPickupTime.compareTo(b.desiredPickupTime));

    return orderList.reversed.toList();
  } catch (error) {
    print('Error fetching order history: $error');
    return [];
  }
}

Future<List> returnOrderHistory(String selectedTime) async{
  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');



  try {
    final orderCollectionSnapshot = await orderCollectionRef.get();
    List orderList = [];
    orderCollectionSnapshot.docs.forEach((doc) {
      if (doc.get('type') == 'Expense') {
        if (DateTime.parse(doc.get('desiredPickupTime')).toString().split(' ')[0] == DateTime.parse(selectedTime).toString().split(' ')[0]) {
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

Future<Map<String, dynamic>> convertOrderHistoryToMap(String createdAt, String desiredPickupTime, int id, List<dynamic> orderHistory, String paymentMethod, String specialRemarks, String status, num total, String type) async {
  Map<String, dynamic> orderHistoryMap = {};



    orderHistoryMap[DateTime.now().toString().split(' ')[0]] = {
      'createdAt': createdAt,
      'desiredPickupTime': desiredPickupTime,
      'orderID': id,
      'orderHistory': orderHistory,
      'paymentMethod': paymentMethod,
      'specialRemarks': specialRemarks,
      'status': status,
      'total': total,
      'type': type,
    };


  return orderHistoryMap;
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

void RefundUserWallet(double amount) {
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
  createOrderHistory([], "", "", amount, randomNumber, "", "Refund");

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

Future<double> getPointsGained(String orderID) async {
  double points = 0.0;
  print(orderID.toString());

  try {
    final userDocumentRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('points')
        .doc(orderID);

    final documentSnapshot = await userDocumentRef.get();

    if (documentSnapshot.exists) {
      // Safely access the 'points' field and ensure it's of type double
      points = (documentSnapshot.data()?['points'] ?? 0.0).toDouble();
    } else {
      print('Document does not exist');
    }
  } catch (error) {
    print('Error fetching points: $error');
  }

  return points;
}


Future<int> getcheckinCounter() async {
  final userDocumentRef = FirebaseFirestore.instance.collection('users').doc(currentUser);
  int checkinCounter = 0;
  String lastCheckedIn = "";

  DocumentSnapshot value = await userDocumentRef.get();
  checkinCounter = value.get('checkinCounter').toInt();
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


  if (now.difference(lastCheckedInTime).inHours < 24) {
    isCheckin = false;
  } else if (now.difference(lastCheckedInTime).inHours >= 24 && now.difference(lastCheckedInTime).inHours < 48) {
    isCheckin = true;
  } else {
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
    double userPoints = value.get('points');
    userPoints = userPoints - double.parse(points);
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

Future<Map<String, dynamic>> getOrderDetails(String uniqueID) async {
  Map<String, dynamic> orderDetails = {};

  final orderCollectionRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history')
      .doc(uniqueID);

  try {
    final orderDocumentSnapshot = await orderCollectionRef.get();
      orderDetails['orderID'] = orderDocumentSnapshot.get('id');
      orderDetails['orderHistory'] = orderDocumentSnapshot.get('orderHistory');
      orderDetails['status'] = orderDocumentSnapshot.get('status');
      orderDetails['createdAt'] = orderDocumentSnapshot.get('createdAt');
      orderDetails['specialRemarks'] = orderDocumentSnapshot.get('specialRemarks');
      orderDetails['desiredPickupTime'] = orderDocumentSnapshot.get('desiredPickupTime');
      orderDetails['total'] = orderDocumentSnapshot.get('total');
      orderDetails['paymentMethod'] = orderDocumentSnapshot.get('paymentMethod');
      orderDetails['type'] = orderDocumentSnapshot.get('type');
  } catch (error) {
    print('Error fetching order details: $error');
  }


 return orderDetails;
}


Future<void> createReview(List<dynamic> orderHistory, int id) async {
  String category = "";

  for (var history in orderHistory) {
    final reviewCollectionRef = FirebaseFirestore.instance
        .collection('admin')
        .doc('reviews')
        .collection(history['name']);

    final menuCollectionRef = FirebaseFirestore.instance
        .collection('menu');

    final menuSnapshot = await menuCollectionRef.get();

    for (var doc in menuSnapshot.docs) {
      final docData = doc.data() as Map<String, dynamic>;
      if (docData['name'] == history['name']) {
        double currentRating = docData['totalRating']?.toDouble() ?? 0.0;
        int currentRatingCount = docData['totalUsersRating']?.toInt() ?? 0;

        currentRatingCount += 1;
        currentRating += history['rating'];
        double newRating = currentRating / currentRatingCount;

        // Update the document with the new rating values
        await menuCollectionRef.doc(doc.id).update({
          'rating': newRating,
          'totalRating': currentRating,
          'totalUsersRating': currentRatingCount,
          'createdAt': DateTime.now().toString(),
        });
      }
    }

    String comment = history['comment']?.trim() ?? '';
    List<dynamic> sentiment;
    if (comment.isEmpty) {
      // Set sentiment to None if comment is empty
      sentiment = [
        {'label': 'positive', 'score': 0.0},
        {'label': 'neutral', 'score': 0.0},
        {'label': 'negative', 'score': 0.0},
      ];
      comment = "None"; // Use "None" if there's no comment
    } else {
      sentiment = await analyzeComment(comment);
    }

    // Add review to the reviews collection
    await reviewCollectionRef.doc(id.toString()).set({
      'id': id,
      'userID': currentUser,
      'comment': history['comment'],
      'rating': history['rating'],
      'quantity': history['quantity'],
      'createdAt': DateTime.now().toString(),
      'positive': sentiment[0]['score'],
      'neutral': sentiment[1]['score'],
      'negative': sentiment[2]['score'],
    });

    // Update history status
    await updateHistoryStatus(id, "Completed and Reviewed");
  }

  // Initialize time zones
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kuala_Lumpur'));

  // Schedule notification
  DateTime tempTime = DateTime.now().add(Duration(seconds: 10));
  print("Time: ${tz.TZDateTime.from(tempTime, tz.local)}");
  print("Current Time: ${DateTime.now()}");
  NotificationService().scheduleNotification(
    title: 'Scheduled Notification',
    body: 'Testing',
    scheduledNotificationDateTime: DateTime.now().add(Duration(seconds: 10)),
  );
}

Future<String> returnCategorywithName(String name) async {
  final menuCollectionRef = FirebaseFirestore.instance.collection('menu');

  try {
    final menuSnapshot = await menuCollectionRef.get();
    String category = "";

    for (var doc in menuSnapshot.docs) {
      final docData = doc.data() as Map<String, dynamic>;
      if (docData['name'] == name) {
        category = docData['category'];
      }
    }

    return category;
  } catch (error) {
    print('Error fetching category: $error');
    return "";
  }
}


Future<List<dynamic>> analyzeComment(String inputText) async {
  final response = await hfInference.fillMask(
    model: 'cardiffnlp/twitter-roberta-base-sentiment',
    inputs: [inputText],
  );

  //improved version
  Map<String, String> labelMapping = {
    'LABEL_0': 'negative',
    'LABEL_1': 'neutral',
    'LABEL_2': 'positive',
  };

  for (var i = 0; i < response[0].length; i++) {
    String label = response[0][i]['label'];
    if (labelMapping.containsKey(label)) {
      response[0][i]['label'] = labelMapping[label];
    }
  }

  response[0].sort((a, b) {
    const order = ['positive', 'neutral', 'negative'];
    return order.indexOf(a['label']).compareTo(order.indexOf(b['label']));
  });


  return response[0];
}

Future<void> updateHistoryStatus(int id, String status) async {
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

Future<Map<DateTime, List<Map<String,dynamic>>>> getCalendarData() async {
  Map<DateTime, List<Map<String, dynamic>>> calendarData = {};

  final calendarDataRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  await calendarDataRef.get().then((value) {
    value.docs.forEach((doc) {
      String type = doc.get('type');
      if (type == 'Expense') {
        String desiredPickupTime = doc.get('desiredPickupTime');
        DateTime dateTime = DateTime.parse(desiredPickupTime);
        DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (calendarData[date] == null) {
          calendarData[date] = [];
        }

        calendarData[date]!.add({
          'createdAt': doc.get('createdAt'),
          'desiredPickupTime': doc.get('desiredPickupTime'),
          'orderID': doc.get('id'),
          'orderHistory': doc.get('orderHistory'),
          'paymentMethod': doc.get('paymentMethod'),
          'specialRemarks': doc.get('specialRemarks'),
          'status': doc.get('status'),
          'total': doc.get('total'),
          'type': doc.get('type'),
        });
      }
    });
  });

  return calendarData;
}

Future<Map<DateTime, List<Map<String,dynamic>>>> getTodayCalendarData() async {
  Map<DateTime, List<Map<String, dynamic>>> calendarData = {};

  final calendarDataRef = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('history');

  await calendarDataRef.get().then((value) {
    value.docs.forEach((doc) {
      String type = doc.get('type');
      if (type == 'Expense') {
        String desiredPickupTime = doc.get('desiredPickupTime');
        DateTime dateTime = DateTime.parse(desiredPickupTime);
        DateTime date = DateTime(dateTime.year, dateTime.month, dateTime.day);

        if (date == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
          if (calendarData[date] == null) {
            calendarData[date] = [];
          }

          calendarData[date]!.add({
            'createdAt': doc.get('createdAt'),
            'desiredPickupTime': doc.get('desiredPickupTime'),
            'orderID': doc.get('id'),
            'orderHistory': doc.get('orderHistory'),
            'paymentMethod': doc.get('paymentMethod'),
            'specialRemarks': doc.get('specialRemarks'),
            'status': doc.get('status'),
            'total': doc.get('total'),
            'type': doc.get('type'),
          });
      }
    });
  });

  return calendarData;
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

String TimeStampToDayMonthYearFormatter(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
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

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}
