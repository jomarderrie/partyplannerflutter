import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partyplanner/helper/helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import '../Person.dart';
import '../Party.dart';

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
    getContactPermission();
    // print(widget.party.toJson());
    // var status = await Permission.calendar.status;
    // if (status.isDenied || status.isPermanentlyDenied) {
    //   // request permission
    //   status = await Permission.calendar.request();
    // }
    // if (status.isGranted) {
    // }
  }

  Future<PermissionStatus> getContactPermission() async {
    final PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
      await [Permission.contacts].request();
      return permissionStatus[Permission.contacts] ??
          PermissionStatus.denied;
    } else {
      return permission;
    }
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
            Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF0D47A1),
                                  Color(0xFF1976D2),
                                  Color(0xFF42A5F5),
                                ],
                              ),
                            ),
                          ),
                        ),

                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () async {
                            Contact? newContact = await ContactsService.openDeviceContactPicker();
                            if(newContact != null){
                              Person newPersonGoingToParty = Person(referenceId: newContact.identifier!, name: newContact.displayName!);
                              widget.party.invites.add(newPersonGoingToParty);
                              List<dynamic> parties = file_data['parties'];
                              parties.forEach((party) {
                                if(party.id == widget.party.id){
                                  party['invited'] = widget.party.invites;
                                }
                              });
                              file_data['parties'] = parties;
                              await writeToFile(file_data);
                             // parties.
                            }
                            print(newContact);
                            print("Add contact");
                          },
                          child: const Text('Invite new person from contacts'),
                        ),
                      ],
                    ),
                  )
                ]
            ),
            // SingleChildScrollView(
            //   child: Column(
            //     children: items
            //         .map((item) => ListTile(
            //       title: Text(item),
            //     ))
            //         .toList(),
            //   ),
            // // ),
            // SingleChildScrollView(
            //   key: context.widget.key,

            // ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.party.invites.length,
                itemBuilder: ( context, index) {
                  return ListTile(
                    title: Text("asd"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
