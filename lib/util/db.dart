import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future checkIfUserExistsAndCreateUser(String email) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('users')
        .doc(email) // varuId in your case
        .get();

    if (snapShot == null || !snapShot.exists) {
      // docuement is not exist
      print('New user. Creating a starter record');
      final data = createNewUserData(email);
      final writeNewUser  = await writeNewUserToDB(email, data);
      print("Created new user ${email} with data ${data}");
    } else {
      print("id is really exist");
    }
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
      {"completedVersion":0,"date":date,"id":7},
      {"id":8,"date":date,"completedVersion":1},
      {"id":9,"completedVersion":1,"date":date}
    ];

    return {"status": items};
  }

  Future<Map<String, List<dynamic>>> initialDataLoad(email) async {
    CollectionReference data = db.collection('data');

    final rules = ((await data.doc("config").get()).data()
        as Map<String, dynamic>)['ruleslist'] as List<dynamic>;
    final user = ((await db.collection("users").doc(email).get()).data()
        as Map<String, dynamic>)['status'] as List<dynamic>;
    return {"rules": rules, "user": user};
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



  Future<void> updateUserStatus(email, data) async {
    final conn = db.collection("users");
    return conn
        .doc(email)
        .update({"status": data})
        .then((value) => print("Data Added $data"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateVersionStatus(
      email, key, int oldVal, dynamic newVal, oldDate, newDate) async {
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
