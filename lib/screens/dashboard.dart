import 'dart:convert';

import 'package:arnet_helper/screens/requirement_edit.dart';
import 'package:arnet_helper/util/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expansion_tile_card/expansion_tile_card.dart';

class Dashboard extends StatelessWidget {
   Dashboard({super.key});
    final email = "uhsarp@gmail.com";
  final DB db = DB();
  @override
  Widget build(BuildContext context) {
    CollectionReference data = FirebaseFirestore.instance.collection('data');
    return FutureBuilder<Map<dynamic, List<dynamic>>>(
      future: db.initialDataLoad(email),
      builder: (BuildContext context,
          AsyncSnapshot<Map<dynamic, List<dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return Spinner(text: 'Something went wrong...');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final docs = snapshot.data!;

          return MyHomePage(
              title: 'ARNET Helper',
              items: snapshot.data!['user']!,
              rules: snapshot.data!['rules']!,
            email: email
          );
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
          title: Text(this.text),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage(
      {super.key,
      required this.title,
      required this.items,
      required this.rules,
      required this.email});

  final String title;
  final List<dynamic> rules;
  final List<dynamic> items;
  final String email;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MM/dd/yy');
    final today = new DateTime.now();
    Map<String, dynamic> findDueDays(src, target) {
      //No due date
      if (target.containsKey("version")) {
        return {"dueDate": "N/A", "dueDays": -1};
      } else {
        final from = df.parse(src['date']);
        final to = from.add(Duration(days: target['frequency']));
        return {
          "dueDate": df.format(to),
          "dueDays": (to.difference(today).inHours / 24).round()
        };
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

    List calc(List items, List rules) {
      List results = [];
      items.forEach((src) {
        final target =
            rules.firstWhere((element) => element['id'] == src['id']);
        if (target != null) {
          final Map<String, dynamic> due = findDueDays(src, target);
          final dueDays = due['dueDays'];
          final dueDate = due['dueDate'];
          final result = {
            "title": target['title'],
            "id": target['id'],
            "frequency": target['frequency'],
            "date": src['date'],
            "completedVersion": src['completedVersion'],
            "frequencyText": target['frequencyText'],
            "requiredVersion":target['version'],
            "footer": target['footer'],
            "dueIn": dueDays,
            "dueDate": dueDate,
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
 /*   print(json.encode(widget.items));
    print(json.encode(widget.rules));*/

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
                    onPressed: () => {

                    },
                    icon: Icon(Icons.sync),
                  ),

                ],
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(widget.title)),
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
                        child: Center(child: Requirement(map: data[index], email: widget.email)),
                      );
                    },
                  ),
                )
              ],
            ) // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}

class Requirement extends StatelessWidget {
  final Map map;

  final String email;

  const Requirement({super.key, required this.map, required this.email});

  @override
  Widget build(BuildContext context) {
    return new ExpansionTileCard(
      baseColor: calcColor(map['severity']),
      expandedColor: calcColor(map['severity']),
      title: Text(
        this.map['title'],
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Text(
            "Expires in days: ${this.map['dueIn'] < 0 ? "N/A" : this.map['dueIn']} ",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          )),
          Container(
            child: Column(
              children: [
                Container(
                    child: Text(
                  "${this.map['footer']} ${this.map['date']}",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                )),
              ],
            ),
          )
        ],
      ),
      children: [
        Row(
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(

                    context: context,
                    builder: (context) {
                      return Dialog(
                          insetPadding: EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 3,
                        child: Container(
                          child: ReqEditForm(map: map, email:email),
                        ),
                      );
                    },
                  );
                },
              ),
            ))
          ],
        ),
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
                    "Required Version: ${this.map['requiredVersion']}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  ),
                )
              ],
            ),
            Container(
              child: Column(
                children: [
                  Container(
                      child: Text(
                    "${this.map['footer']} ${this.map['date']}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  )),
                  Container(
                      child: Text(
                    "Expires in days: ${this.map['dueIn'] < 0 ? "N/A" : this.map['dueIn']} ",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  )),
                  Container(
                    child: Text(
                      "id: ${this.map['id']}",
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                    ),
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
    if (severity < 1) return Colors.green[100];
    if (severity < 6) return Colors.amber[100];
    return Colors.red[100];
  }
}
