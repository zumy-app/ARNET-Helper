import 'package:arnet_helper/screens/requirements/RecurringRequirement.dart';
import 'package:arnet_helper/screens/requirements/VersionRequirement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReqEditForm extends StatefulWidget {
  final Map map;
  final String email;
  ReqEditForm({super.key, required this.map, required this.email});

  final test = [
    {
      "title": "Personally Identifiable Information (PII) V5",
      "id": 5,
      "frequency": -1,
      "date": "5/18/2021",
      "completedVersion": 3,
      "frequencyText": "Once as updated",
      "footer": "Last Taken on",
      "dueIn": -1,
      "dueDate": "N/A",
      "severity": 10,
      "notes":
          "https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nDOD-US1366 Or \nhttps://cyber.mil/cyber-training/training-catalog/\nIdentifying and Safeguarding Personally Identifiable Information (PII)"
    },
    {
      "title": "Social Networking",
      "id": 8,
      "frequency": -1,
      "date": "12/27/2021",
      "completedVersion": 2.1,
      "frequencyText": "Once as updated",
      "footer": "Last Taken on",
      "dueIn": -1,
      "dueDate": "N/A",
      "severity": 10,
      "notes":
          "https://iatraining.us.army.mil\nhttps://jkosupport.jten.mil \nPAC-J7-US001-08\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nSocial Networking and Your Online Identity"
    },
    {
      "title": "Phishing Awareness ",
      "id": 9,
      "frequency": -1,
      "date": "1/13/2022",
      "completedVersion": 5,
      "frequencyText": "Once as updated",
      "footer": "Last Taken on",
      "dueIn": -1,
      "dueDate": "N/A",
      "severity": 10,
      "notes":
          "https://jkosupport.jten.mil \nSOC-AFR-0100-SOCAFRICA\nOr \nhttps://cyber.mil/cyber-training/training-catalog/\nPhishing and Social Engineering: Virtual Communication Awareness Training"
    },
    {
      "title": "Sign in to ARNET",
      "id": 1,
      "frequency": 30,
      "date": "9/24/2022",
      "completedVersion": null,
      "frequencyText": "Monthly Requirement",
      "footer": "Last Signed in on",
      "dueIn": 9,
      "dueDate": "10/24/22",
      "severity": 5,
      "notes":
          "Sign in to ARNET from any Army Reserve location or remotely through Citrix"
    },
    {
      "title": "Army IT User Agreement",
      "id": 2,
      "frequency": 364,
      "date": "3/11/2022",
      "completedVersion": null,
      "frequencyText": "Annual Requirement",
      "footer": "Last uploaded on",
      "dueIn": 146,
      "dueDate": "03/10/23",
      "severity": 0,
      "notes": "Upload 75-R annually on https://atcts.army.mil/iastar/login.php"
    },
    {
      "title": "DD 2875",
      "id": 3,
      "frequency": 364,
      "date": "3/25/2022",
      "completedVersion": null,
      "frequencyText": "Annual Requirement",
      "footer": "Last uploaded on",
      "dueIn": 160,
      "dueDate": "03/24/23",
      "severity": 0,
      "notes":
          "Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php"
    },
    {
      "title": "DoD Cyber Awareness Challenge Training",
      "id": 4,
      "frequency": 364,
      "date": "3/11/2022",
      "completedVersion": null,
      "frequencyText": "Annual Requirement",
      "footer": "Last Taken On",
      "dueIn": 146,
      "dueDate": "03/10/23",
      "severity": 0,
      "notes": "https://cs.signal.army.mil OR https://jkodirect.jten.mil"
    },
    {
      "title": "PED and Removable Storage ",
      "id": 6,
      "frequency": -1,
      "date": "5/18/2021",
      "completedVersion": 2,
      "frequencyText": "Once as updated",
      "footer": "Last Taken on",
      "dueIn": -1,
      "dueDate": "N/A",
      "severity": 0,
      "notes": "Not Currently Available"
    },
    {
      "title": "Safe Home Computing",
      "id": 7,
      "frequency": -1,
      "date": "4/11/2021",
      "completedVersion": 0,
      "frequencyText": "Once as updated",
      "footer": "Last Taken on",
      "dueIn": -1,
      "dueDate": "N/A",
      "severity": 0,
      "notes": "Not Currently Available"
    }
  ];

  @override
  State<ReqEditForm> createState() => _ReqEditFormState(map);
}

class _ReqEditFormState extends State<ReqEditForm> {
  final map;
  _ReqEditFormState(this.map);
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
        child: map['frequency'] > 0
            ? RecurringRequirement(map: map,email:widget.email)
            : VersionRequirement(map: map, email:widget.email)
      ),
    );
  }

  _submit() {}
}
