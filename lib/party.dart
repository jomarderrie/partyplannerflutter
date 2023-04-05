class Party {
  final String id;
final String name;
final String description;
final String startDate;
final String endDate;

Party({
  required this.id,
  required this.name,
  required this.description,
  required this.startDate,
  required this.endDate
});

factory Party.fromJson(Map<dynamic, dynamic> json){
  return Party(id: json["id"], name: json["name"], description: json["description"],
      startDate: json["startDate"], endDate: json["endDate"]);
}

Map<String, dynamic> toJson(){
  return{
    "id": id,
    "name": name,
    "description": description,
    "startDate": startDate,
    "endDate": endDate
  };
}
}
