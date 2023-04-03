import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:device_calendar/device_calendar.dart';
import '../party.dart';

class AddPartyScreen extends StatefulWidget {
  @override
  _AddPartyScreenState createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Location _currentLocation = tz.getLocation('Europe/Amsterdam');
  DateTime? _selectedDate;
  DateTime? endPartyDate;

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
    final events = <Event>[
      Event(   calendar.data?.first.id,
        title: _nameController.text,
        start: DateTime.now().to,
        end: DateTime.now().add(Duration(hours: 1)),
        description: _descriptionController.text
      ),
    ];
    // final event = CalendarEvent(
    //   title: 'My event',
    //   description: 'Description of my event',
    //   startDate: DateTime.now(),
    //   endDate: DateTime.now().add(Duration(hours: 2)),
    //   location: '123 Main St, Anytown USA',
    // );

    // await FlutterNativeCalendar.addEvent(event);
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
                    : 'Party Date end and Time: ${DateFormat.yMd().add_jm().format(_selectedDate!)}'),
                onTap: _selectDate,
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(endPartyDate == null
                    ? 'Select Party end Date and Time'
                    : 'Party Date end and Time: ${DateFormat.yMd().add_jm().format(endPartyDate!)}'),
                onTap: _endPartyDate,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _selectedDate != null && endPartyDate != null) {
            final partyObj = party(
              name: _nameController.text,
              description: _descriptionController.text,
              startDate: _selectedDate!,
              endDate: endPartyDate!,
            );
            addEventToCalander();

            Navigator.pop(context, partyObj);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }


}