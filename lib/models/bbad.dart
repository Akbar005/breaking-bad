import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'bbad.g.dart';

@JsonSerializable()
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

  factory Bbad.fromJson(Map<String, dynamic> json) => _$BbadFromJson(json);

  Map<String, dynamic> toJson() => _$BbadToJson(this);
}
