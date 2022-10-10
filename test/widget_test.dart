// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:arnet_helper/firebase_options.dart';
import 'package:arnet_helper/util/db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arnet_helper/main.dart';

void main() {
  test('Counter increments smoke test', () async {
    // Build our app and trigger a frame.

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    List items = [
      {
        "id": 1,
        //Must match the corresponding ID in the rules list to find the applicable rules
        "date": "9/24/2022"
      },
      {
        "id": 2,
        "date": "3/11/2022"
      },
      {
        "id": 3,
        "date": "3/25/2022"
      },
      {
        "id": 4,
        "date": "3/11/2022"
      },
      {
        "id": 5,
        "completedVersion": 3,
        "date": "5/18/2021"
      },
      {
        "id": 6,
        "completedVersion": 2,
        "date": "5/18/2021"
      },
      {
        "id": 7,
        "completedVersion": 0,
        "date": "4/11/2021"
      },
      {
        "id": 8,
        "completedVersion": 2.1,
        "date": "12/27/2021"
      },
      {
        "id": 9,
        "completedVersion": 5,
        "date": "1/13/2022"
      }
    ];

    List rules = [
      {
        "title": "Sign in to ARNET",
        "id": 1,
        "frequency": 30, //in days
        "frequencyText": "Monthly Requirement",
        "footer": "Last Signed in on",
        "notes":
        "Sign in to ARNET from any Army Reserve location or remotely through Citrix"
      },
      {
        "title": "Army IT User Agreement",
        "id": 2,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "notes":
        "Upload 75-R annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DD 2875",
        "id": 3,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "notes":
        "Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DoD Cyber Awareness Challenge Training",
        "id": 4,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last Taken On",
        "notes": "https://cs.signal.army.mil OR https://jkodirect.jten.mil"
      },
      {
        "title": "Personally Identifiable Information (PII) V5",
        "id": 5,
        "frequency": 364,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "notes": """https://iatraining.us.army.mil
https://jkosupport.jten.mil 
DOD-US1366 Or 
https://cyber.mil/cyber-training/training-catalog/
Identifying and Safeguarding Personally Identifiable Information (PII)"""
      },
      {
        "title": "PED and Removable Storage ",
        "id": 6,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 2,
        "notes": "Not Currently Available"
      },
      {
        "title": "Safe Home Computing",
        "id": 7,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": -1,
        "notes": "Not Currently Available"
      },
      {
        "title": "Social Networking",
        "id": 8,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 4,
        "notes": """https://iatraining.us.army.mil
https://jkosupport.jten.mil 
PAC-J7-US001-08
Or 
https://cyber.mil/cyber-training/training-catalog/
Social Networking and Your Online Identity"""
      },
      {
        "title": "Phishing Awareness ",
        "id": 9,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 6,
        "notes": """https://jkosupport.jten.mil 
SOC-AFR-0100-SOCAFRICA
Or 
https://cyber.mil/cyber-training/training-catalog/
Phishing and Social Engineering: Virtual Communication Awareness Training"""
      }
    ];
    final db = new DB();
  });


}
