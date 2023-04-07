import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:partyplanner/helper/helper.dart';
import '../Party.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';


class AddPartyScreen extends StatefulWidget {
  @override
  _AddPartyScreenState createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Location _currentLocation = getLocation('Europe/Amsterdam');
  DateTime? _selectedDate;
  DateTime? endPartyDate;

  Future setCurentLocation() async {
    String timezone = 'Europe/Amsterdam';
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } catch (e) {
      print('Could not get the local timezone');
    }
    _currentLocation = getLocation(timezone);
    setLocalLocation(_currentLocation);
  }
  //
  // @override
  // void initState() {
  //   calanderPermission();
  //   final dateTime = DateTime.now().add(Duration(hours: 1));
  //   final dateTime2 = DateTime.now().add(Duration(hours: 2));
  //   Party party = Party(id: "13", name: "asd", description: "yup", startDate: dateTime.toIso8601String(), endDate: dateTime2.toIso8601String());
  //   print(file_data);
  //   createNewParty(party);
  // }

  void createNewParty(Party newParty) async {
    _formKey.currentState?.save();
    Map<String, dynamic> party = newParty.toJson();
    file_data['parties'].add(party);
    await writeToFile(file_data);
    print(file_data);
  }

  Future<void> calanderPermission() async {
    var status = await Permission.calendar.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      // request permission
      status = await Permission.calendar.request();
    }
    if (status.isGranted) {
    }
  }

  void _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }


  Future<void> addEventToCalander() async {
    final calendar = await DeviceCalendarPlugin().retrieveCalendars();
    final event =
    Event(calendar.data?.first.id,
        title: _nameController.text,
        start: tz.TZDateTime.from(_selectedDate!, _currentLocation),
        end: tz.TZDateTime.from(endPartyDate!, _currentLocation),
        description: _descriptionController.text
    );
    var status = await Permission.calendar.request();
    if (status.isGranted) {
      final result = await DeviceCalendarPlugin().createOrUpdateEvent(event);
      if (result!.isSuccess && result.data != null) {
        print('Event added to calendar.');
      } else {
        print('Failed to add event to calendar.');
      }
    }
  }

  Future<void> _endPartyDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          endPartyDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Party'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Party Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a party name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Party Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a party description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Party start Date and Time'
                    : 'Party date end and Time: ${DateFormat.yMd().add_jm().format(_selectedDate!)}'),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(endPartyDate == null
                    ? 'Select Party end Date and Time'
                    : 'Party Date end and Time: ${DateFormat.yMd().add_jm().format(endPartyDate!)}'),
                onTap: _endPartyDate,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child:   ClipRRect(
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
                              onPressed: () {
                                if (_formKey.currentState!.validate() && _selectedDate != null && endPartyDate != null) {
                                  var uuid = Uuid();
                                  final partyObj = Party(
                                    id: uuid.v4(),
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    startDate: _selectedDate!.toIso8601String(),
                                    endDate: endPartyDate!.toIso8601String(),
                                    invites: []
                                  );
                                  createNewParty(partyObj);
                                  addEventToCalander();

                                  Navigator.pop(context, partyObj);
                                }
                              },
                              child: const Text('Save party'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]
              ),
            ],
          ),
        ),
      ),

      // Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Expanded(
      //         flex: 1,
      //         child: TextButton(
      //           child: Text(text),
      //         ),
      //       )
      //     ]
      // ),

    );
  }
}