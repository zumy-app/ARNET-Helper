
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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



class Response<T>{
  final bool success;
  final T data;
  final String msg;

  Response(this.success, this.data, this.msg);

}