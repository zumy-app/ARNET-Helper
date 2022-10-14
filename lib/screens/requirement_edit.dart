import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReqEditForm extends StatefulWidget {

  final Map map;
   ReqEditForm({super.key, required this.map});
  final  test =[{"title":"Personally Identifiable Information (PII) V5","id":5,"frequency":-1,"date":"5/18/2021","completedVersion":3,"frequencyText":"Once as updated","footer":"Last Taken on","dueIn":-1,"severity":10,"notes":"https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nDOD-US1366 Or \nhttps://cyber.mil/cyber-training/training-catalog/\nIdentifying and Safeguarding Personally Identifiable Information (PII)"},{"title":"Social Networking","id":8,"frequency":-1,"date":"12/27/2021","completedVersion":2.1,"frequencyText":"Once as updated","footer":"Last Taken on","dueIn":-1,"severity":10,"notes":"https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nPAC-J7-US001-08\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nSocial Networking and Your Online Identity"},{"title":"Phishing Awareness ","id":9,"frequency":-1,"date":"1/13/2022","completedVersion":5,"frequencyText":"Once as updated","footer":"Last Taken on","dueIn":-1,"severity":10,"notes":"https://jkosupport.jten.mil \nSOC-AFR-0100-SOCAFRICA\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nPhishing and Social Engineering: Virtual Communication Awareness Training"},{"title":"Sign in to ARNET","id":1,"frequency":30,"date":"9/24/2022","completedVersion":null,"frequencyText":"Monthly Requirement","footer":"Last Signed in on","dueIn":11,"severity":5,"notes":"Sign in to ARNET from any Army Reserve location or remotely through Citrix"},{"title":"Army IT User Agreement","id":2,"frequency":364,"date":"3/11/2022","completedVersion":null,"frequencyText":"Annual Requirement","footer":"Last uploaded on","dueIn":148,"severity":0,"notes":"Upload 75-R annually on https://atcts.army.mil/iastar/login.php"},{"title":"DD 2875","id":3,"frequency":364,"date":"3/25/2022","completedVersion":null,"frequencyText":"Annual Requirement","footer":"Last uploaded on","dueIn":162,"severity":0,"notes":"Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php"},{"title":"DoD Cyber Awareness Challenge Training","id":4,"frequency":364,"date":"3/11/2022","completedVersion":null,"frequencyText":"Annual Requirement","footer":"Last Taken On","dueIn":148,"severity":0,"notes":"https://cs.signal.army.mil OR https://jkodirect.jten.mil"},{"title":"PED and Removable Storage ","id":6,"frequency":-1,"date":"5/18/2021","completedVersion":2,"frequencyText":"Once as updated","footer":"Last Taken on","dueIn":-1,"severity":0,"notes":"Not Currently Available"},{"title":"Safe Home Computing","id":7,"frequency":-1,"date":"4/11/2021","completedVersion":0,"frequencyText":"Once as updated","footer":"Last Taken on","dueIn":-1,"severity":0,"notes":"Not Currently Available"}];


  @override
  State<ReqEditForm> createState() => _ReqEditFormState(test[3]);
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ReqEditFormState extends State<ReqEditForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
   final map;
  _ReqEditFormState( this.map);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }
/*
possible edit types
1. recurring requirement (monthly/annual)
2. version
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(map['title']),
        leading: Icon(Icons.filter_vintage),
      ),
      //body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //form
        child: map['frequency']>0? RecurringRequirement(map:map): VersionRequirement(map:map),
      ),
    );
  }

  _submit() {}
}

class RecurringRequirement extends StatefulWidget {
  final Map map;
  const RecurringRequirement({Key? key, required this.map}) : super(key: key);

  @override
  State<RecurringRequirement> createState() => _RecurringRequirementState(map);
}

class _RecurringRequirementState extends State<RecurringRequirement> {
  final Map map;
  TextEditingController dateInput = TextEditingController();

  _RecurringRequirementState(this.map);
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Container(
              child:Text(
                "Expires in days: ${map['dueIn']<0?"N/A":map['dueIn']} on ${map['date']}",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )
          ),
          Container(
              child:Text(
                "${map['footer']} ${map['date']}",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )
          ), Container(
              child:Text(
                "This is a recurring requirement to be completed every ${map['frequency']} days",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )
          ),
          Container(
              child:Text(
                "Enter the updated date below",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )
          ),
          //styling
          Container(
              padding: EdgeInsets.all(15),

              child: Center(
                  child: TextField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

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
                onPressed: () => _submit(),
              ),
              TextButton(
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                onPressed: () => _submit(),
              )
            ],
          ),

        ],
      ),
    );
  }

  _submit() {}
}

class VersionRequirement extends StatefulWidget {
  final Map map;
  const VersionRequirement({Key? key, required this.map}) : super(key: key);

  @override
  State<VersionRequirement> createState() => _VersionRequirementState();
}

class _VersionRequirementState extends State<VersionRequirement> {
  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          Text(
            "Update the last completed version",
            style: TextStyle(fontSize: 14),
          ),
          //styling

          Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.width / 3,
              child: Center(
                  child: TextField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

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
                onPressed: () => _submit(),
              ),
              TextButton(
                child: Text(
                  "Update",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                onPressed: () => _submit(),
              )
            ],
          ),

        ],
      ),
    );
  }

  _submit() {}
}
