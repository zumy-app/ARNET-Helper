import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';

class ProfilePage extends StatefulWidget {

  final dynamic user;
  //User data in Firebase
  final dynamic userData;

  const ProfilePage({Key? key, required this.user, required this.userData})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

var selectedVersion;

class _ProfilePageState extends State<ProfilePage> {

  final DB db = DB();
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();

  @override
  void initState() {

    dateInput.text = DateFormat("MM/dd/yyyy")
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isInteger(num value) => (value % 1) == 0;
print(widget.user);
print("userData:");
print(widget.userData);

    List<dynamic> list = [];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Text(
            "Required Version: ",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
          //styling

          Row(
            children: [
              Text(
                "Enter the last  completed version    ",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              SizedBox(
                width: 100.0,
                child: Container(),
              )
            ],
          ),
          Container(
              width: 250,
              child: Center(
                child: TextField(
                  controller: dateInput,
                  //editing controller of this TextField
                  decoration: InputDecoration(
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText:
                      "Enter the new completion date" //label text of field
                  ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      print(
                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate =
                      DateFormat('MM/dd/yyyy').format(pickedDate);
                      print(
                          formattedDate); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        dateInput.text =
                            formattedDate; //set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              )),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text(
                  "Update",
                  style: TextStyle(
                      fontSize: 24.0),
                ),
                onPressed: () {
                  _formKey.currentState!.validate();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  _submit() {

  }
}
