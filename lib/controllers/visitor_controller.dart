import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Visitor {
  final String id; // Add id field

  final String name;
  final String purpose;
  final String contact;
  final String flatNo;
  final bool isApproved;
  bool checkedIn;

  Visitor({
    required this.id,
    required this.name,
    required this.purpose,
    required this.contact,
    required this.flatNo,
    this.isApproved = false,
    this.checkedIn = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'purpose': purpose,
        'contact': contact,
        'flatNo': flatNo,
        'isApproved': isApproved,
        'checkedIn': checkedIn,
      };

  static Visitor fromJson(Map<String, dynamic> json) => Visitor(
        id: json['id'],
        name: json['name'],
        purpose: json['purpose'],
        contact: json['contact'],
        flatNo: json['flatNo'],
        isApproved: json['isApproved'],
        checkedIn: json['checkedIn'],
      );
}

class VisitorController extends GetxController {
  var db = FirebaseFirestore.instance;
  var visitors = <Visitor>[].obs;

  final TextEditingController visitorNameController = TextEditingController();
  final TextEditingController visitorPurposeController =
      TextEditingController();
  final TextEditingController visitorContactController =
      TextEditingController();
  final TextEditingController visitorFlatNoController = TextEditingController();

  @override
  void onInit() {
    print("hi");
    loadVisitors();
    super.onInit();
  }

  void loadVisitors() async {
    db.collection("visitorsData").snapshots().listen(
      (querySnapshot) {
        visitors.value = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Add the document ID to the data
          return Visitor.fromJson(data);
        }).toList();
      },
      onError: (e) => print("Error completing: $e"),
    );

    // final prefs = await SharedPreferences.getInstance();
    // final jsonList = prefs.getStringList('visitors') ?? [];
    // visitors.value = jsonList
    //     .map((jsonStr) => Visitor.fromJson(jsonDecode(jsonStr)))
    //     .toList();
  }

  Future<void> saveVisitors() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = visitors.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList('visitors', jsonList);
  }

  void clearVisitors() async {
    // visitors.clear();
    try {
      QuerySnapshot querySnapshot = await db.collection('visitorsData').get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      print("All documents in visitorsData collection have been deleted.");
    } catch (e) {
      print("Error clearing visitorsData collection: $e");
    }
  }

  void registerVisitor(
      String name, String purpose, String contact, String flatNo) async {
    // Add visitor to Firestore and get the document ID
    var docRef = await db.collection("visitorsData").add({
      'name': name,
      'purpose': purpose,
      'contact': contact,
      'flatNo': flatNo,
      'checkedIn': false,
      'isApproved': false,
    });
    var newVisitor = Visitor(
        id: docRef.id, // Use the document ID
        name: name,
        purpose: purpose,
        contact: contact,
        flatNo: flatNo);
    visitors.add(newVisitor);
    saveVisitors(); // Save to shared preferences
    Get.snackbar('Success', 'Visitor Registered: $name');
  }

  Future<void> addVisitorToFirestore(
      String name, String purpose, String contact, String flatNo) async {
    try {
      await db.collection("visitorsData").add({
        'name': name,
        'purpose': purpose,
        'contact': contact,
        'flatNo': flatNo,
        'checkedIn': false,
        'isApproved': false,
      });
      print("Visitor added to Firestore: $name");
      visitorContactController.clear();
      visitorFlatNoController.clear();
      visitorNameController.clear();
      visitorPurposeController.clear();
      Get.snackbar('Success', 'Visitor Registered: $name');
    } catch (e) {
      print("Error adding visitor to Firestore: $e");
    }
  }

  Future<void> deleteVisitor(String id) async {
    try {
      await db.collection("visitorsData").doc(id).delete();
      visitors.removeWhere((visitor) => visitor.id == id);
      saveVisitors(); // Update local storage
      print("Visitor deleted from Firestore: $id");
    } catch (e) {
      print("Error deleting visitor from Firestore: $e");
    }
  }
}
