class AddLocationModel {
  String location;
  String exp;
  String id;
  num soluong;
  AddLocationModel({
    required this.location,
    required this.exp,
    required this.id,
    required this.soluong,
  });

  toJson() {
    return {
      "id": id,
      "location": location,
      "exp": exp,
      "soluong": soluong,
    };
  }
}
