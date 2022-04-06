class Bbad {
  int id;
  String name;
  String birthday;
  String img;
  String status;
  String nickname;
  String portrayed;
  String category;

  Bbad({
    this.id,
    this.name,
    this.birthday,
    this.img,
    this.status,
    this.nickname,
    this.portrayed,
    this.category,
  });

  Bbad.fromJson(Map json) {
    id = json["char_id"];
    name = json["name"];
    img = json["img"];
    birthday = json["birthday"];
    status = json["status"];
    nickname = json["nickname"];
    portrayed = json["portrayed"];
    category = json["category"];
  }
}
