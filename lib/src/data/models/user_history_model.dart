// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tem_final/src/data/models/user_choice_model.dart';
import 'package:tem_final/src/data/models/user_rating_model.dart';

class UserHistoryModel {
  final String idUser;
  final List<UserChoiceModel> listUserChoices;
  final List<UserRatingModel> listUserRatings;
  final String deviceId;
  const UserHistoryModel(
      {required this.idUser,
      required this.listUserChoices,
      required this.listUserRatings,
      required this.deviceId});

  UserHistoryModel copyWith({
    String? idUser,
    List<UserChoiceModel>? listUserChoices,
    List<UserRatingModel>? listUserRatings,
    String? deviceId,
  }) {
    return UserHistoryModel(
      idUser: idUser ?? this.idUser,
      listUserChoices: listUserChoices ?? this.listUserChoices,
      listUserRatings: listUserRatings ?? this.listUserRatings,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idUser': idUser,
      'listUserChoices': listUserChoices.map((x) => x.toMap()).toList(),
      'listUserRatings': listUserRatings.map((x) => x.toMap()).toList(),
      'deviceId': deviceId
    };
  }

  factory UserHistoryModel.fromMap(Map<String, dynamic> map) {
    return UserHistoryModel(
        idUser: map['idUser'] as String,
        listUserChoices: List<UserChoiceModel>.from(
          (map['listUserChoices']).map<UserChoiceModel>(
            (x) => UserChoiceModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        listUserRatings: List<UserRatingModel>.from(
          (map['listUserRatings']).map<UserRatingModel>(
            (x) => UserRatingModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        deviceId: map['deviceId']);
  }

  String toJson() => json.encode(toMap());

  factory UserHistoryModel.fromJson(String source) =>
      UserHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserHistoryModel(idUser: $idUser, listUserChoices: $listUserChoices, listUserRatings: $listUserRatings, deviceId $deviceId)';

  @override
  bool operator ==(covariant UserHistoryModel other) {
    if (identical(this, other)) return true;

    return other.idUser == idUser &&
        listEquals(other.listUserChoices, listUserChoices) &&
        listEquals(other.listUserRatings, listUserRatings) &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode =>
      idUser.hashCode ^
      listUserChoices.hashCode ^
      listUserRatings.hashCode ^
      deviceId.hashCode;
}
