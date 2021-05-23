class ListData {
  String id;
  String title;

  ListData({this.title, this.id});
  // Open the database and store the reference.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }
}
