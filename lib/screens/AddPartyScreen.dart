import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPartyScreen extends StatefulWidget {
  @override
  _AddPartyScreenState createState() => _AddPartyScreenState();
}

class _AddPartyScreenState extends State<AddPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

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
              SizedBox(height: 16.0),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Party Date and Time'
                    : 'Party Date and Time: ${DateFormat.yMd().add_jm().format(_selectedDate!)}'),
                onTap: _selectDate,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _selectedDate != null) {
            final party = party(

            );

            Navigator.pop(context, party);
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}