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

      menuList.add(MenuClass(
        name: doc['name'].toString(),
        description: doc['description'].toString(),
        imageURL: downloadURL,
        price: doc['price'],
        rating: doc['rating'].toString(),
      ));
    }));

    return menuList;
  } catch (error) {
    print('Error fetching menu data: $error');
    return [];
  }
}



