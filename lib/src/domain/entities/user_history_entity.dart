// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/user_choice_entity.dart';
import 'package:tem_final/src/domain/entities/user_rating_entity.dart';

class UserHistory extends Equatable {
  final String idUser;
  final List<UserChoice> listUserChoices;
  final List<UserRating> listUserRatings;
  const UserHistory(
      {required this.idUser,
      required this.listUserChoices,
      required this.listUserRatings});

  @override
  List<Object> get props => [idUser];
}
