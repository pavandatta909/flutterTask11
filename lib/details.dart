class DetailsList {
  int? id;
  String? first_name;
  String? last_name;
  String? email;
  String? gender;
  String? c_time;

  DetailsList(
      {this.id,
      this.first_name,
      this.last_name,
      this.email,
      this.gender,
      this.c_time});

  DetailsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    first_name = json['first_name'];
    last_name = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    c_time = json['c_time'];
  }
}
