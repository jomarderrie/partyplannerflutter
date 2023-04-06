import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../party.dart';

class PartyDetailScreen extends StatefulWidget {

  const PartyDetailScreen({  required this.party});

  final Party party;
  @override
  _PartyDetailScreenState createState() =>
    _PartyDetailScreenState();
}
class _PartyDetailScreenState extends State<PartyDetailScreen>{
  @override
  void initState() {
    print(widget.party.toJson());

  }

  @override
  Widget build(BuildContext context) {
    // String name = party['name'];
    // String description = party['description'];
    // DateTime startDate = DateTime.parse(party['startDate']);
    // DateTime endDate = DateTime.parse(party['endDate']);
    // DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text("yup"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "yup",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "yup",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Start Date: ',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'End Date:',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
