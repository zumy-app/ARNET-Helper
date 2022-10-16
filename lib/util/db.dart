
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
class DB{
 read(collection, document, key){
   FirebaseFirestore.instance
       .collection(collection)
      .doc(document)
       .get()
       .then((DocumentSnapshot documentSnapshot) {
     if (documentSnapshot.exists) {
       return documentSnapshot.get(key);
     }
   });
}

 Future<void> writeRulesToDB( data) async {
   final conn = FirebaseFirestore.instance.collection("data");
   return conn.doc("config")
       .update({"ruleslist":data})
       .then((value) => print("Data Added $data"))
       .catchError((error) => print("Failed to add user: $error"));
 }


 Future<void> updateUserStatus(email, data) async {
   final conn = FirebaseFirestore.instance.collection("users");
   return conn.doc(email)
       .update({"status":data})
       .then((value) => print("Data Added $data"))
       .catchError((error) => print("Failed to add user: $error"));
 }

 Future<void> updateVersionStatus(email, key,int oldVal,int newVal, oldDate, newDate) async {
   final conn = FirebaseFirestore.instance.collection("users")
       .doc(email);

   conn.update({
     "status": FieldValue.arrayRemove([{
       "completedVersion":oldVal,
       "date":oldDate,
       "id":key
     }]),
   }).then((value) => print("value"));

   conn.update({
     "status": FieldValue.arrayUnion([{
       "completedVersion":newVal,
       "date":newDate,
       "id":key
     }]),
   }).then((value) => print("value"));
 }

 Future<void> updateReqStatus(email, id, oldDate, newDate) async {
   final conn = FirebaseFirestore.instance.collection("users")
       .doc(email);

   conn.update({
     "status": FieldValue.arrayRemove([{
       "date":oldDate,
       "id":id
     }]),
   }).then((value) => print("value"));

   conn.update({
     "status": FieldValue.arrayUnion([{
       "date":newDate,
       "id":id
     }]),
   }).then((value) => print("value"));

 }

}




class Response<T>{
  final bool success;
  final T data;
  final String msg;

  Response(this.success, this.data, this.msg);

}