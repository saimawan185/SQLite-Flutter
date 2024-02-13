class Notes {
  final int? id;
  final String? title;
  final String? description;

  Notes({this.id, this.title, this.description});

  Notes.fromMap(Map<String, dynamic> note)
      : id = note["id"],
        title = note["title"],
        description = note["description"];

  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "description": description};
  }
}
