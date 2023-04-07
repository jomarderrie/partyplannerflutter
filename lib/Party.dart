import 'package:partyplanner/Person.dart';

class Party {
  final String id;
final String name;
final String description;
final String startDate;
final String endDate;
List<Person> invites = [];

Party({
  required this.id,
  required this.name,
  required this.description,
  required this.startDate,
  required this.endDate,
  required this.invites
});

factory Party.fromJson(Map<dynamic, dynamic> json){
  return Party(id: json["id"], name: json["name"], description: json["description"],
      startDate: json["startDate"], endDate: json["endDate"],
      invites: (json['invited'] as List).map((e) =>
        Person.fromJson(e),
      ).toList()
  );
}

Map<String, dynamic> toJson(){
  return{
    "id": id,
    "name": name,
    "description": description,
    "startDate": startDate,
    "endDate": endDate,
    "invited": invites.map((e) => e.toJson()).toList()
  };
}
  void addPersonToParty({required Person person}) {
    invites.add(person);
  }

  int get numberOfInvitees {
    return invites.length;
  }

}
