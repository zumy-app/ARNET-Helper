import 'package:arnet_helper/util/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
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

Future<Map<String, List<dynamic>>> initialDataLoad(email) async {

  var db = FirebaseFirestore.instance;
  CollectionReference data = db.collection('data');

  final rules = ((await data.doc("config").get()).data() as Map<String, dynamic>) ['ruleslist'] as List<dynamic>;
  final user = ((await db.collection("users").doc(email).get()).data() as Map<String, dynamic>) ['status'] as List<dynamic>;
  return {"rules":rules, "user": user};
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    CollectionReference data = FirebaseFirestore.instance.collection('data');
    return FutureBuilder<Map<dynamic, List<dynamic>>>(
      future:  initialDataLoad("uhsarp@gmail.com"),
      builder:
          (BuildContext context, AsyncSnapshot<Map<dynamic, List<dynamic>>> snapshot) {

        if (snapshot.hasError) {
          return Spinner(text: 'Something went wrong...');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final docs = snapshot.data!;

          return MyHomePage(title: 'ARNET Helper', items: snapshot.data!['user']! , rules: snapshot.data!['rules']!);
        }

        return Spinner(text: 'Loading...');
      },
    );
  }
}


class Spinner extends StatelessWidget {
  final String text;
  const Spinner({super.key, required this.text});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title:  Text(this.text),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.items, required this.rules});


  final String title;
  final List<dynamic> rules;
  final List<dynamic> items;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    final df = DateFormat('MM/dd/yy');
    final today = new DateTime.now();
    num findDueDays(src, target) {
      //No due date
      if (target.containsKey("version")) {
        return -1;
      } else {
        final from = df.parse(src['date']);
        final to = from.add(Duration(days: target['frequency']));
        return (to.difference(today).inHours / 24).round();
      }
    }
//From a scale of 0 to 10
    calcSeverity(num dueDays, src, target) {
      //Eg: An annual requirement, anything above a month
      if (target['frequency'] > 35) {
        if (dueDays < 0) return 10;
        if (dueDays < 31) return 5;
        if (dueDays < 365) return 0;
      }
      //Eg: Monthly requirement
      if (target['frequency'] > 0) {
        if (dueDays < 0) return 10;
        if (dueDays < 30) return 5;
        return 0;
      }
      //Eg: No annual/monthly requirement. Only take the most recent version
      if (target['frequency'] < 0) {
        if (src['completedVersion'] < target['version']) return 10;
        return 0;
      }
    }

    calcSummary(List results) {
      var lowestDue = 99999999;
      var lowestReq = {};
      results.forEach((e) {
        if (e['dueIn'] < lowestDue && e['dueIn']>0) {
          lowestDue = e['dueIn'];
          lowestReq = e;
        }
      });
      return lowestReq;
    }

    List calc(List items, List rules) {
      List results = [];
      items.forEach((src) {
        final target =
            rules.firstWhere((element) => element['id'] == src['id']);
        if (target != null) {
          var dueDays = findDueDays(src, target);
          final result = {
            "title": target['title'],
            "id": target['id'],
            "frequency": target['frequency'],
            "date": src['date'],
            "completedVersion": src['completedVersion'],
            "version": src['version'],
            "frequencyText": target['frequencyText'],
            "footer": target['footer'],
            "dueIn": dueDays,
            "severity": calcSeverity(dueDays, src, target),
            "notes": target['notes']
          };
          results.add(result);
        }
      });

       results.sort((a, b) => (b['severity']).compareTo(a['severity']));
       return results;
    }

    final data = calc(widget.items, widget.rules);



    // final writeUserRules = writeToDB("data", "users", "status", data);


    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
            actions: [
              IconButton(
                onPressed: () => {},
                icon: Icon(Icons.update),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title)
        ),
        body: Column(
          children: <Widget>[
          /*  Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Center(
                  child: Summary(
                      map:lowest
              )),
            ),*/
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // Let the ListView know how many items it needs to build.
                itemCount: data.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Center(
                        child: Requirement(
                          map:data[index])),
                  );
                },
              ),
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        )
    );
  }
}

class Summary extends StatelessWidget {
  final Map map;

  const Summary(
      {Key? key,
      required this.map})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3),
            child: Text(
              "Access expires in",
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
            ),
            alignment: Alignment.topLeft,
          ),
          Center(
              child: Text(
            "${this.map['dueIn']} days",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          )),
          Container(
              child: Text(
                "on ${this.map['date']} ",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              alignment: Alignment.bottomRight)
        ],
      ),
      decoration: BoxDecoration(
          color: this.map['color'], borderRadius: BorderRadius.circular(20)),
    );
  }
}

class Requirement extends StatelessWidget {
  final Map map;

  const Requirement(
      {super.key,
      required this.map});

  @override
  Widget build(BuildContext context) {
    return new ExpansionTileCard(
      title:Text(
        this.map['title'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      children: [
        Container(
          child: Text(
            this.map['title'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                this.map['frequencyText'],
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      child:Text(
                        "${this.map['footer']} ${this.map['date']}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                      )
                  ),
                  Container(
                      child:Text(
                        "Expires in days: ${this.map['dueIn']<0?"N/A":this.map['dueIn']} ",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                      )
                  ),

                ],

              ),
            )
          ],
        ),
      ],

    );
  }

  calcColor(severity) {
    if(severity<1)
      return Colors.green[100];
    if(severity<6)
      return Colors.amber[100];
    if(severity>6)
      return Colors.red[100];

  }

  initialDataLoad(){

    List items = [
      {
        "id": 1,
        //Must match the corresponding ID in the rules list to find the applicable rules
        "date": "9/24/2022"
      },
      {
        "id": 2,
        "date": "3/11/2022"
      },
      {
        "id": 3,
        "date": "3/25/2022"
      },
      {
        "id": 4,
        "date": "3/11/2022"
      },
      {
        "id": 5,
        "completedVersion": 3,
        "date": "5/18/2021"
      },
      {
        "id": 6,
        "completedVersion": 2,
        "date": "5/18/2021"
      },
      {
        "id": 7,
        "completedVersion": 0,
        "date": "4/11/2021"
      },
      {
        "id": 8,
        "completedVersion": 2.1,
        "date": "12/27/2021"
      },
      {
        "id": 9,
        "completedVersion": 5,
        "date": "1/13/2022"
      }
    ];

    List rules = [
      {
        "title": "Sign in to ARNET",
        "id": 1,
        "frequency": 30, //in days
        "frequencyText": "Monthly Requirement",
        "footer": "Last Signed in on",
        "notes":
        "Sign in to ARNET from any Army Reserve location or remotely through Citrix"
      },
      {
        "title": "Army IT User Agreement",
        "id": 2,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "notes":
        "Upload 75-R annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DD 2875",
        "id": 3,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "notes":
        "Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DoD Cyber Awareness Challenge Training",
        "id": 4,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "footer": "Last Taken On",
        "notes": "https://cs.signal.army.mil OR https://jkodirect.jten.mil"
      },
      {
        "title": "Personally Identifiable Information (PII) V5",
        "id": 5,
        "frequency": 364,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "notes": """https://iatraining.us.army.mil
https://jkosupport.jten.mil 
DOD-US1366 Or 
https://cyber.mil/cyber-training/training-catalog/
Identifying and Safeguarding Personally Identifiable Information (PII)"""
      },
      {
        "title": "PED and Removable Storage ",
        "id": 6,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 2,
        "notes": "Not Currently Available"
      },
      {
        "title": "Safe Home Computing",
        "id": 7,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": -1,
        "notes": "Not Currently Available"
      },
      {
        "title": "Social Networking",
        "id": 8,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 4,
        "notes": """https://iatraining.us.army.mil
https://jkosupport.jten.mil 
PAC-J7-US001-08
Or 
https://cyber.mil/cyber-training/training-catalog/
Social Networking and Your Online Identity"""
      },
      {
        "title": "Phishing Awareness ",
        "id": 9,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "version": 6,
        "notes": """https://jkosupport.jten.mil 
SOC-AFR-0100-SOCAFRICA
Or 
https://cyber.mil/cyber-training/training-catalog/
Phishing and Social Engineering: Virtual Communication Awareness Training"""
      }
    ];
    writeRulesToDB(rules);
    updateUserStatus("uhsarp@gmail.com", items);
  }
}

