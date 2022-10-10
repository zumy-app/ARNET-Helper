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
      baseColor: calcColor(map['severity']),
      expandedColor:calcColor(map['severity']),
      title:Text(
        this.map['title'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child:Text(
                "Expires in days: ${this.map['dueIn']<0?"N/A":this.map['dueIn']} ",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              )
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


              ],

            ),
          )
        ],
      ),

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Column(
             children: [
               Container(
                 child: Text(
                   "Frequency: ${this.map['frequencyText']}",
                   style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                 ),
               ),
               Container(
                 child: Text(
                   "Completed Version: ${this.map['completedVersion']}",
                   style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                 ),
               ),
               Container(
                 child: Text(
                   "Required Version: ${this.map['version']}",
                   style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                 ),
               )
             ],
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
        Container(
          child: Text(
            "Notes: ${this.map['notes']}",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
        )

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
}

