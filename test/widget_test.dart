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

    List items = [{"date":"9/24/2022","id":1},{"id":2,"date":"3/11/2022"},{"date":"3/25/2022","id":3},{"date":"3/11/2022","id":4},{"id":5,"date":"5/18/2021","completedVersion":3},{"id":6,"date":"5/18/2021","completedVersion":2},{"completedVersion":0,"date":"4/11/2021","id":7},{"id":8,"date":"12/27/2021","completedVersion":2.1},{"id":9,"completedVersion":5,"date":"1/13/2022"}];

    List rules = [{"footer":"Last Signed in on","frequencyText":"Monthly Requirement","notes":"Sign in to ARNET from any Army Reserve location or remotely through Citrix","frequency":30,"title":"Sign in to ARNET","id":1},{"notes":"Upload 75-R annually on https://atcts.army.mil/iastar/login.php","frequency":364,"title":"Army IT User Agreement","id":2,"frequencyText":"Annual Requirement","footer":"Last uploaded on"},{"footer":"Last uploaded on","title":"DD 2875","frequency":364,"notes":"Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php","id":3,"frequencyText":"Annual Requirement"},{"title":"DoD Cyber Awareness Challenge Training","notes":"https://cs.signal.army.mil OR https://jkodirect.jten.mil","frequency":364,"footer":"Last Taken On","frequencyText":"Annual Requirement","id":4},{"footer":"Last Taken on","frequencyText":"Once as updated","id":5,"frequency":-1,"notes":"https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nDOD-US1366 Or \nhttps://cyber.mil/cyber-training/training-catalog/\nIdentifying and Safeguarding Personally Identifiable Information (PII)","title":"Personally Identifiable Information (PII) V5","version":5},{"version":2,"id":6,"frequency":-1,"footer":"Last Taken on","notes":"Not Currently Available","frequencyText":"Once as updated","title":"PED and Removable Storage "},{"id":7,"version":-1,"title":"Safe Home Computing","footer":"Last Taken on","notes":"Not Currently Available","frequency":-1,"frequencyText":"Once as updated"},{"id":8,"footer":"Last Taken on","version":4,"notes":"https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nPAC-J7-US001-08\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nSocial Networking and Your Online Identity","frequency":-1,"title":"Social Networking","frequencyText":"Once as updated"},{"notes":"https://jkosupport.jten.mil \nSOC-AFR-0100-SOCAFRICA\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nPhishing and Social Engineering: Virtual Communication Awareness Training","footer":"Last Taken on","version":6,"frequencyText":"Once as updated","frequency":-1,"id":9,"title":"Phishing Awareness "}];
    final db = new DB();
  });


}
