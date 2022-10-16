
import 'dart:ui';

import 'package:arnet_helper/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';

class RecurringRequirement extends StatefulWidget {
  final Map map;
  final String email;


   RecurringRequirement({Key? key, required this.map, required this.email}) : super(key: key);

  @override
  State<RecurringRequirement> createState() => _RecurringRequirementState(map);
}

class _RecurringRequirementState extends State<RecurringRequirement> {
  final Map map;
  TextEditingController dateInput = TextEditingController();
  final DB db = DB();
  _RecurringRequirementState(this.map);

  @override
  void initState() {
    dateInput.text = DateFormat("MM/dd/yyyy").format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Container(
              child: Text(
                "Expires in days: ${map['dueIn'] < 0 ? "N/A" : map['dueIn']} on ${map['dueDate']}",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )),
          Container(
              child: Text(
                "${map['footer']} ${map['date']}",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )),
          Container(
              child: Text(
                "This is a recurring requirement to be completed every ${map['frequency']} days",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )),
          //styling
          Container(
              padding: EdgeInsets.all(15),
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
                  ))),

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
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                onPressed: () => _submit(dateInput.text),
              )
            ],
          ),
        ],
      ),
    );
  }

  _submit(date) {
    print("updating ${widget.map['id']} from ${widget.map['date']} to ${dateInput.text}");
    db.updateReqStatus(widget.email, widget.map['id'],widget.map['date'], dateInput.text);
  Navigator.pop(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Dashboard()), (r) => false);
  }
}

