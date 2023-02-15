// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';

class UserChoice extends Equatable {
  final String idTvShowAndMovie;
  final int seasonSelected;
  final ConclusionType conclusionSelected;

  const UserChoice({
    required this.idTvShowAndMovie,
    required this.seasonSelected,
    required this.conclusionSelected,
  });

  @override
  List<Object> get props =>
      [idTvShowAndMovie, seasonSelected, conclusionSelected];
}
