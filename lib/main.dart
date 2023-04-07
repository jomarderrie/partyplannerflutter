import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:partyplanner/screens/PartyDetailScreen.dart';

import 'Party.dart';
import 'screens/AddPartyScreen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'helper/helper.dart';

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
      title: 'Flutter party planner',
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
      home: const MyHomePage(title: 'Flutter party planner'),
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
  List<Party> _parties = [];
  String _jsonString = '';
  bool _loading = true;

  void createFileOnInit() async {
    filePath = await localFile;
    bool filePathExist = filePath.existsSync();
    if(!filePathExist){
      await initFile();
      _initData();
    }else{
      _initData();
    }
  }

  @override
  void initState() {
    createFileOnInit();
  }

  void _initData() async{
    filePath = await localFile;
    try {
      _jsonString = await filePath.readAsString();
      file_data = jsonDecode(_jsonString);
      print(file_data);
     var parties2 = (file_data['parties'] as List)
          .map((data) => Party.fromJson(data))
          .toList();
      print(parties2);
      setState(() {
        _parties = parties2;
        _loading = false;
      });
    } catch (e) {
      print('Tried reading _file error: $e');
    }
  }
  void _addParty(Party partyObj) {
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
            // final formattedDate = DateFormat.yMd().add_jm().format(party.startDate);
            return ListTile(
              title: Text(party.name),
              subtitle: Text(party.startDate),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PartyDetailScreen(party: party)),
                ).then((value) => _initData());
              }
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final party = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPartyScreen(
              )),
            ).then((value) => _initData());
            print("IjustGOtBack");
            // if (party != null) {
            //   _addParty(party);
            // }
          },
          tooltip: 'Add Party',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
