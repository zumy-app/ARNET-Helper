import 'dart:convert';

import 'package:battle_buddy/main.dart';
import 'package:battle_buddy/screens/profile/profile_page.dart';
import 'package:battle_buddy/screens/requirement_edit.dart';
import 'package:battle_buddy/util/db.dart';

import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:battle_buddy/services/firebase_auth_methods.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'feedback/custom_feedback.dart';
import 'feedback/feedback_functions.dart';
class Dashboard extends StatelessWidget {
  final User ssoUserData;
   Dashboard({Key? key, required this.ssoUserData})
      : super(key: key);
  final DB db = DB();


  @override
  Widget build(BuildContext context) {

    return FutureBuilder<Map<dynamic, dynamic>>(
      future: db.initialDataLoad(ssoUserData),
      builder: (BuildContext context,
          AsyncSnapshot<Map<dynamic, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Spinner(
              text: 'Something went wrong...'
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final docs = snapshot.data!;

          return MyHomePage(
              title: 'Battle Buddy',
              fbUserData: snapshot.data!['fbUserData']!,
              rules: snapshot.data!['rules']!,
            ssoUserData: ssoUserData
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
          leading: MaterialButton(
            padding: const EdgeInsets.all(10),
            color: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: const Text(
              'LOG OUT',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: () {
             FirebaseAuth.instance.signOut();
            },
          ),
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
      required this.fbUserData,
      required this.rules,
      required this.ssoUserData});

  final String title;
  final List<dynamic> rules;
  final Map<dynamic, dynamic> fbUserData;
  final User ssoUserData;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
bool _useCustomFeedback = true;

class DashboardPage extends StatelessWidget {
  const DashboardPage(this.toggleCustomizedFeedback, this.title, this.arnetUserDataCalculated, this.ssoUserData, this.fbUserData, {Key? key}) : super(key: key);
  final VoidCallback toggleCustomizedFeedback;
  final title;
  final arnetUserDataCalculated;
  final ssoUserData;
  final fbUserData;
  @override
  Widget build(BuildContext context) {

      return Scaffold(
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                 UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: const Color(0xff764abc)),
                  accountName: Text(
                    this.ssoUserData!.displayName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    dbRef.getEmail(ssoUserData),
                    // this.user!.email,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  currentAccountPicture: Image.asset('assets/icons/1024.png'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                  ),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                  ),
                  title: const Text('Profile'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          elevation: 3,
                          child: ProfilePage(ssoUserData: ssoUserData, fbUserData: fbUserData),
                        );
                      },
                    );
                  },
                ),
                AboutListTile( // <-- SEE HERE
                  icon: Icon(
                    Icons.info,
                  ),
                  child: Text('About app'),
                  applicationIcon: Icon(
                    Icons.local_play,
                  ),
                  applicationName: 'Battle Buddy ',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2022 Zumy LLC',
                  aboutBoxChildren: [
                    ///Content goes here...
                  ],
                ),
              ],
            ),
          ),
          appBar: AppBar(
              centerTitle: true,
                 /*    leading: IconButton(
                onPressed: () {},
                icon: Icon(Icons.home),
              ),*/
            actions: [
                IconButton(
                  onPressed: () => {
                    context.read<FirebaseAuthMethods>().signOut(context)

                  },
                  icon: Icon(Icons.logout),
                ),

              ],
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text(title)),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              BetterFeedback.of(context).show(
                    (feedback) async {
                  // upload to server, share whatever
                  // for example purposes just show it to the user
                      final feedbackId = await dbRef.provideFeedback(ssoUserData,feedback);
                  alertFeedbackFunction(
                    context,
                    feedback,
                    feedbackId
                  );
                },
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.feedback),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  // Let the ListView know how many items it needs to build.
                  itemCount: arnetUserDataCalculated.length,
                  // Provide a builder function. This is where the magic happens.
                  // Convert each item into a widget based on the type of item it is.
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Center(child: Requirement(map: arnetUserDataCalculated[index], user: ssoUserData)),
                    );
                  },
                ),
              )
            ],
          ) // This trailing comma makes auto-formatting nicer for build methods.
      );

  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Use either of them.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isProfileEmpty = await dbRef.checkIfProfileEmpty(dbRef.getEmail(widget.ssoUserData));
      if(isProfileEmpty) {
        await showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              Dialog(
                insetPadding: EdgeInsets.all(30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 10,
                child: Container(
                  child: ProfilePage(
                      ssoUserData: widget.ssoUserData, fbUserData: widget.fbUserData),
                ),
              ),
        );
      }
    });
  }

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

    List calc(Map fbUserData, List rules) {
      List results = [];
      final items = fbUserData['status'] as List<dynamic>;
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

    final arnetUserDataCalculated = calc(widget.fbUserData, widget.rules);
    void _toggleCustomizedFeedback() =>
        setState(() => _useCustomFeedback = !_useCustomFeedback);
    return BetterFeedback(
        child: Container(
        child: DashboardPage(_toggleCustomizedFeedback,widget.title, arnetUserDataCalculated, widget.ssoUserData, widget.fbUserData),
    ),
      feedbackBuilder: _useCustomFeedback
          ? (context, onSubmit, scrollController) => CustomFeedbackForm(
        onSubmit: onSubmit,
        scrollController: scrollController,
      )
          : null,
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),
      localizationsDelegates: [
        GlobalFeedbackLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeOverride: const Locale('en'),
      mode: FeedbackMode.draw,
      pixelRatio: 1,
    );
  }
}

class Requirement extends StatelessWidget {
  final Map map;

  final User user;

  const Requirement({super.key, required this.map, required this.user});

  @override
  Widget build(BuildContext context) {
    return new ExpansionTileCard(
      baseColor: calcColor(map['severity']),
      expandedColor: calcColor(map['severity']),
      title: Text(
        this.map['title'],
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
               Text(
            "Expires in days: ${this.map['dueIn'] < 0 ? "N/A" : this.map['dueIn']} ",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
          ),
          Text(
            "${this.map['footer']} ${this.map['date']}",
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
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
                          child: ReqEditForm(map: map, user:user),
                        ),
                      );
                    },
                  );
                },
              ),
            ))
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                   Text(
                    "Frequency: ${this.map['frequencyText']}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  ),
        if(this.map['completedVersion']!=null)
               Text(
                    "Completed Version: ${this.map['completedVersion']}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  ),
if(this.map['requiredVersion']!=null)
                Text(
                 "Required Version: ${this.map['requiredVersion']}",
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
                  ),

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
