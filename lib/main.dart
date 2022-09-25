import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ARNET Helper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['A', 'B', 'C'];
    final List<int> colorCodes = <int>[600, 500, 100];
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    Map summary = {
      'header': "Access expires in",
      'eta': "183",
      'footer': "On",
      'date': "2/22/2023"
    };

    List items = [
      {
        "title": "Sign in to ARNET",
        "id": 1,
        //Must match the corresponding ID in the rules list to find the applicable rules
        "frequencyText": "Monthly Requirement",
        "footer": "Last Signed in on",
        "date": "9/24/2022"
      },
      {
        "title": "Army IT User Agreement",
        "id": 2,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "date": "3/11/2022"
      },
      {
        "title": "DD 2875",
        "id": 3,
        "frequencyText": "Annual Requirement",
        "footer": "Last uploaded on",
        "date": "3/25/2022"
      },
      {
        "title": "DoD Cyber Awareness Challenge Training",
        "id": 4,
        "frequencyText": "Annual Requirement",
        "footer": "Last Taken On",
        "date": "3/11/2022"
      },
      {
        "title": "Personally Identifiable Information (PII) V5",
        "id": 5,
        "frequencyText": "Once as updated",
        "completedVersion": 3,
        "footer": "Last Taken on",
        "date": "5/18/2021"
      },
      {
        "title": "PED and Removable Storage ",
        "id": 6,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "completedVersion": 2,
        "date": "5/18/2021"
      },
      {
        "title": "Safe Home Computing",
        "id": 7,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "completedVersion": 0,
        "date": "4/11/2021"
      },
      {
        "title": "Social Networking",
        "id": 8,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
        "completedVersion": 2.1,
        "date": "12/27/2021"
      },
      {
        "title": "Phishing Awareness ",
        "id": 9,
        "frequencyText": "Once as updated",
        "footer": "Last Taken on",
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
        "notes":
            "Sign in to ARNET from any Army Reserve location or remotely through Citrix"
      },
      {
        "title": "Army IT User Agreement",
        "id": 2,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "notes":
            "Upload 75-R annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DD 2875",
        "id": 3,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "notes":
            "Upload DD 2875 annually on https://atcts.army.mil/iastar/login.php"
      },
      {
        "title": "DoD Cyber Awareness Challenge Training",
        "id": 4,
        "frequency": 364,
        "frequencyText": "Annual Requirement",
        "notes": "https://cs.signal.army.mil OR https://jkodirect.jten.mil"
      },
      {
        "title": "Personally Identifiable Information (PII) V5",
        "id": 5,
        "frequency": 364,
        "frequencyText": "Once as updated",
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
        "version": 2,
        "notes": "Not Currently Available"
      },
      {
        "title": "Safe Home Computing",
        "id": 7,
        "frequency": -1,
        "frequencyText": "Once as updated",
        "version": -1,
        "notes": "Not Currently Available"
      },
      {
        "title": "Social Networking",
        "id": 8,
        "frequency": -1,
        "frequencyText": "Once as updated",
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
        "version": 6,
        "notes": """https://jkosupport.jten.mil 
SOC-AFR-0100-SOCAFRICA
Or 
https://cyber.mil/cyber-training/training-catalog/
Phishing and Social Engineering: Virtual Communication Awareness Training"""
      }
    ];

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

    findColor(num dueDays, src, target) {
      //Eg: An annual requirement, anything above a month
      if (target['frequency'] > 35) {
        if (dueDays < 0) return Colors.red[100];
        if (dueDays < 31) return Colors.amber[100];
        if (dueDays < 365) return Colors.green[100];
      }
      //Eg: Monthly requirement
      if (target['frequency'] > 0) {
        if (dueDays < 0) return Colors.red[100];
        if (dueDays < 7) return Colors.amber[100];
        return Colors.green[100];
      }
      //Eg: No annual/monthly requirement. Only take the most recent version
      if (target['frequency'] < 0) {
        if (src['completedVersion'] < target['version']) return Colors.red[100];
        return Colors.green[100];
      }
    }

    calcSummary(List results) {
      var lowestDue = 99999999;
      var lowestReq = {};
      results.forEach((e) {
        if (e['dueIn'] < lowestDue) lowestDue = e['dueIn'];
        lowestReq = e;
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
            "frequencyText": target['frequencyText'],
            "dueIn": dueDays,
            "color": findColor(dueDays, src, target),
            "notes": target['notes']
          };
          results.add(result);
        }
      });
      return results;
    }

    final data = calc(items, rules);
    final lowest = calcSummary(data);

    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Center(
                  child: Summary(
                header: summary['header'],
                eta: lowest['dueIn'],
                footer: summary['footer'],
                date: summary['date'],
              )),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                // Let the ListView know how many items it needs to build.
                itemCount: items.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Center(
                        child: Requirement(
                            title: items[index]['title'],
                            frequency: items[index]['frequencyText'],
                            footer: items[index]['footer'],
                            date: items[index]['date'])),
                  );
                },
              ),
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class Summary extends StatelessWidget {
  final String header;
  final int eta;
  final String footer;
  final String date;

  const Summary(
      {Key? key,
      required this.header,
      required this.eta,
      required this.date,
      required this.footer})
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
              this.header,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
            ),
            alignment: Alignment.topLeft,
          ),
          Center(
              child: Text(
            "${this.eta} days",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          )),
          Container(
              child: Text(
                "${this.footer} ${this.date} ",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ),
              alignment: Alignment.bottomRight)
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(20)),
    );
  }
}

class Requirement extends StatelessWidget {
  final String title;
  final String frequency;
  final String footer;
  final String date;

  const Requirement(
      {super.key,
      required this.title,
      required this.frequency,
      required this.footer,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              this.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  this.frequency,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                ),
              ),
              Container(
                child: Text(
                  "${this.footer} ${this.date}",
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                ),
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.green[100], borderRadius: BorderRadius.circular(20)),
    );
  }
}
