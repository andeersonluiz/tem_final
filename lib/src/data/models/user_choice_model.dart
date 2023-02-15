// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';

class UserChoiceModel {
  final String idTvShowAndMovie;
  final int seasonSelected;
  final ConclusionType conclusionSelected;

  const UserChoiceModel({
    required this.idTvShowAndMovie,
    required this.seasonSelected,
    required this.conclusionSelected,
  });

  UserChoiceModel copyWith({
    String? idTvShowAndMovie,
    int? seasonSelected,
    ConclusionType? conclusionSelected,
  }) {
    return UserChoiceModel(
      idTvShowAndMovie: idTvShowAndMovie ?? this.idTvShowAndMovie,
      seasonSelected: seasonSelected ?? this.seasonSelected,
      conclusionSelected: conclusionSelected ?? this.conclusionSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'idTvShowAndMovie': idTvShowAndMovie,
      'seasonSelected': seasonSelected,
      'conclusionSelected': conclusionSelected.index,
    };
  }

  factory UserChoiceModel.fromMap(Map<String, dynamic> map) {
    return UserChoiceModel(
        idTvShowAndMovie: map['idTvShowAndMovie'] as String,
        seasonSelected: map['seasonSelected'],
        conclusionSelected: ConclusionType.values[map['conclusionSelected']]);
  }

  String toJson() => json.encode(toMap());

  factory UserChoiceModel.fromJson(String source) =>
      UserChoiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserChoiceModel(idTvShowAndMovie: $idTvShowAndMovie, seasonSelected: $seasonSelected, conclusionSelected: $conclusionSelected)';

  @override
  bool operator ==(covariant UserChoiceModel other) {
    if (identical(this, other)) return true;

    return other.idTvShowAndMovie == idTvShowAndMovie &&
        other.seasonSelected == seasonSelected &&
        other.conclusionSelected == conclusionSelected;
  }

  @override
  int get hashCode =>
      idTvShowAndMovie.hashCode ^
      seasonSelected.hashCode ^
      conclusionSelected.hashCode;
}
