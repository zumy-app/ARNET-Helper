import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/db.dart';
import '../dashboard.dart';

class VersionRequirement extends StatefulWidget {
  final Map map;
  final String email;

  const VersionRequirement({Key? key, required this.map, required this.email})
      : super(key: key);

  @override
  State<VersionRequirement> createState() => _VersionRequirementState(map);
}

var selectedVersion = 1;

class _VersionRequirementState extends State<VersionRequirement> {
  final Map map;
  final DB db = DB();
  final _formKey = GlobalKey<FormState>();
  TextEditingController versionInput = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  _VersionRequirementState(this.map);

  @override
  void initState() {
    versionInput.text = map['completedVersion']
        .toString(); //set the initial value of text field
    dateInput.text = DateFormat("MM/dd/yyyy")
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = <int>[
      for (var i = widget.map['completedVersion'].toInt() as int;
          i <= widget.map['requiredVersion'];
          i++)
        i
    ];
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
                child: DropdownButtonFormField<int>(
                    validator: (value) {
                      if (value == map['completedVersion']) {
                        return 'You have already completed this version';
                      }
                    },
                    hint: Text("Pick"),
                    value: list[0],
                    items: list.map((int value) {
                      return new DropdownMenuItem<int>(
                        value: value,
                        child: new Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                       print("selected ${newVal}");
                      });
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
                    fontSize: 24.0,
                  ),
                ),
                onPressed: () {
                  _formKey.currentState!.validate();
                  // _submit(versionInput.text);
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  _submit(newVal) {
    print(
        "updating ${widget.map['id']} from ${widget.map['date']} to ${dateInput.text} and version ${widget.map['completedVersion']} to ${newVal}");
    db.updateVersionStatus(
        widget.email,
        widget.map['id'],
        widget.map['completedVersion'].toInt(),
        int.parse(newVal),
        widget.map['date'],
        dateInput.text);
    Navigator.pop(context);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Dashboard()), (r) => false);
  }
}
