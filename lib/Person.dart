import 'package:partyplanner/Party.dart';

class Person {
  String referenceId;
  String name;

  Person({
    required this.referenceId,
    required this.name,
  });

  factory Person.fromJson(Map<dynamic, dynamic> json) {
    return Person(
      name: json['name'],
      referenceId: json['referenceId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"name": name, "referenceId": referenceId, };
  }
}