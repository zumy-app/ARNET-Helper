import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';
import '../dashboard.dart';

class VersionRequirement extends StatefulWidget {
  final Map map;
  final User user;

  const VersionRequirement({Key? key, required this.map, required this.user})
      : super(key: key);

  @override
  State<VersionRequirement> createState() => _VersionRequirementState(map);
}

var selectedVersion;

class _VersionRequirementState extends State<VersionRequirement> {
  final Map map;
  final DB db = DB();
  final _formKey = GlobalKey<FormState>();

  TextEditingController dateInput = TextEditingController();

  _VersionRequirementState(this.map);

  @override
  void initState() {

    dateInput.text = DateFormat("MM/dd/yyyy")
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool isInteger(num value) => (value % 1) == 0;

    List<dynamic> list = [];

    if (widget.map['requiredVersion'] < 0) {
      list = [widget.map['completedVersion'], widget.map['requiredVersion']].toSet().toList();
    } else {
      list = <dynamic>[
        for (var i = widget.map['completedVersion'].toInt() as int;
            i <= widget.map['requiredVersion'];
            i++)
          i
      ];
    }
    if (!isInteger(widget.map['completedVersion'])) {
      list[0] = widget.map['completedVersion'];
    }

    print(list.toString());
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Completed Version: ${map['completedVersion']}",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
          Text(
            "Required Version: ${map['requiredVersion']}",
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
                child: DropdownButtonFormField<dynamic>(
                    validator: (value) {
                      if (value == map['completedVersion']) {
                        return 'You have already completed this version';
                      }
                    },
                    hint: Text("Pick"),
                    value: list[0],
                    items: list.map((dynamic value) {
                      return new DropdownMenuItem<dynamic>(
                        value: value,
                        child: new Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      selectedVersion=newVal;
                      print("Selected a new Version ${newVal}");
                    }),
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
                  if(selectedVersion==null)
                      selectedVersion = map['completedVersion'];
                    _submit();
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  _submit() {
    print(
        "updating ${widget.map['id']} from ${widget.map['date']} to ${dateInput.text} and version ${widget.map['completedVersion']} to ${ selectedVersion}");
    db.updateVersionStatus(
        widget.user.email,
        widget.map['id'],
        widget.map['completedVersion'],
       selectedVersion,
        widget.map['date'],
        dateInput.text);
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Dashboard(user:widget.user)), (r) => false);
  }
}
