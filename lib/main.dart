import 'package:flutter/material.dart';

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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

    List items = [
      {
        "title": "DoD Cyber Awareness Challenge Training",
        "frequency": "Annual Requirement",
        "info": "Expires On 2/22/2023"
      },
      {
        "title": "Personally Identifiable Information (PII) V5",
        "frequency": "Once as updated",
        "info": "Last Taken on 2/22/2023"
      }
    ];
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            new Summary(),
            SizedBox(height: 10),
            Expanded(
              child:ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: items.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  return Requirement( title: items[index]['title'],frequency: items[index]['frequency'], info: items[index]['info']);
                },
              ),

            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            child: Text(
              'Access expires in',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
            ),
            alignment: Alignment.topLeft,
          ),
          const Center(
              child: Text(
            '183 Days',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          )),
          Container(
              child: Text(
                'On 2/22/2023',
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
   final String info;

   Requirement({ required this.title, required this.frequency, required this.info});

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
                  this.info,
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
