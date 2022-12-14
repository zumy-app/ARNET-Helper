import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DB {

  final df = DateFormat('MM/dd/yy');
  final today = new DateTime.now();

  final db = FirebaseFirestore.instance;
  Future<void> writeNewUserToDB(email, data) async {
    final conn = db.collection("users");
    return conn
        .doc(email)
        .set(data)
        .then((value) => print("Data Added $data"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<String> checkIfUserExistsAndCreateUser(String email) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email) // varuId in your case
        .get();

    if (snapShot == null || !snapShot.exists) {
      // document does not exist
      print('New user. Creating a starter record');
      final data = createNewUserData(email);
      final writeNewUser  = await writeNewUserToDB(email, data);
      var userCreated = "Created new user ${email} with data ${data}";
      print(userCreated);
      return userCreated;
    } else {
      print("id really exists");
      return "User ${email} already exists. Skipping new user creation process";
    }
  }

  provideFeedback(user, feedback) async {
print("Providing feedback ${feedback} for ${user}");
    final email = getEmail(user);
    final  date = DateTime.now().toIso8601String();
    final name = '${date}.png';
    final screenshot = await storeScreenshot(feedback, name);
    print('Uploaded screenshot ${screenshot}');
    final conn = db.collection("data").doc("other");
    var data = {
      "feedback": FieldValue.arrayUnion([
        {
          "email":email,
          "timestamp": date,
          "screenshot": screenshot,
          "rating": feedback.extra['rating'],
          "type": feedback.extra['feedback_type'],
          "message": feedback.extra['feedback_text']
        }
      ]),
    };
    print(data);
    conn.update(data).then((value) => print("value"));
    return date;
  }
  storeScreenshot(feedback, name) async{
    final storageRef = FirebaseStorage.instance.ref().child('images').child(name);
     var snapshot = await storageRef.putData(feedback.screenshot);
     return snapshot.ref.getDownloadURL();

  }

  createNewUserData(email){
    final oneYearAgo = DateTime(today.year-1,today.month, today.day);
    final date = df.format(oneYearAgo);
    List items = [
      {"date":date,"id":1},
      {"id":2,"date":date},
      {"date":date,"id":3},
      {"date":date,"id":4},
      {"id":5,"date":date,"completedVersion":1},
      {"id":6,"date":date,"completedVersion":1},
      {"completedVersion":-2,"date":date,"id":7},
      {"id":8,"date":date,"completedVersion":1},
      {"id":9,"completedVersion":1,"date":date}
    ];

    return {"status": items,"feedback":[],"profile":{}};
  }

  Future<Map<String, dynamic>> initialDataLoad(User loggedInUser) async {
    CollectionReference data = db.collection('data');

    final rules = ((await data.doc("config").get()).data()
        as Map<String, dynamic>)['ruleslist'] as List<dynamic>;
    final email = getEmail(loggedInUser);
    final fbUserData = ((await db.collection("users").doc(email).get()).data()
        as Map<String, dynamic>);
    return {"rules": rules, "fbUserData": fbUserData};
  }

  getEmail(User loggedInUser){
    if(loggedInUser.email!=null && !loggedInUser.email!.isEmpty)
      return loggedInUser.email!;
    else
      return loggedInUser.providerData[0].email;
  }

  read(collection, document, key) {
    db
        .collection(collection)
        .doc(document)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get(key);
      }
    });
  }

  Future<void> writeRulesToDB(data) async {
    final conn = db.collection("data");
    return conn
        .doc("config")
        .update({"ruleslist": data})
        .then((value) => print("Data Added $data"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> checkIfProfileEmpty(email) async {
    CollectionReference data = db.collection('users');
    final profile = ((await data.doc(email).get()).data()
    as Map<String, dynamic>)['profile'] as Map<String, dynamic>;
    if(profile==null || profile.length==0) return true;
    else return false;
  }

  Future<void> updateUserStatus(email, data) async {
    final conn = db.collection("users");
    return conn
        .doc(email)
        .update({"status": data})
        .then((value) => print("Data Added $data"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  Future<void> updateUserProfile(email, data) async {
    final conn = db.collection("users");
    return conn
        .doc(email)
        .update({"profile": data})
        .then((value) => print("Profile Added $data"))
        .catchError((error) => print("Failed to update profile: $error"));
  }
  Future<void> updateVersionStatus(
      email, key, dynamic oldVal, dynamic newVal, oldDate, newDate) async {
    final conn = db.collection("users").doc(email);

    conn.update({
      "status": FieldValue.arrayRemove([
        {"completedVersion": oldVal, "date": oldDate, "id": key}
      ]),
    }).then((value) => print("value"));

    conn.update({
      "status": FieldValue.arrayUnion([
        {"completedVersion": newVal, "date": newDate, "id": key}
      ]),
    }).then((value) => print("value"));
  }

  Future<void> updateReqStatus(email, id, oldDate, newDate) async {
    final conn = db.collection("users").doc(email);

    conn.update({
      "status": FieldValue.arrayRemove([
        {"date": oldDate, "id": id}
      ]),
    }).then((value) => print("value"));

    conn.update({
      "status": FieldValue.arrayUnion([
        {"date": newDate, "id": id}
      ]),
    }).then((value) => print("value"));
  }
}

class Response<T> {
  final bool success;
  final T data;
  final String msg;

  Response(this.success, this.data, this.msg);
}
