import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'party.dart';
import 'screens/AddPartyScreen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
void main() {
  runApp(const MyApp());
  tzdata.initializeTimeZones();
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final List<party> _parties = [];

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
  void _addParty(party partyObj) {
    setState(() {
      _parties.add(partyObj);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Party Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Upcoming Parties'),
        ),
        body: ListView.builder(
          itemCount: _parties.length,
          itemBuilder: (context, index) {
            final party = _parties[index];
            final formattedDate = DateFormat.yMd().add_jm().format(party.startDate);

            return ListTile(
              title: Text(party.name),
              subtitle: Text(formattedDate),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final party = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPartyScreen()),
            );

            if (party != null) {
              _addParty(party);
            }
          },
          tooltip: 'Add Party',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
