import 'package:tem_final/src/core/resources/mapper.dart';
import 'package:tem_final/src/data/models/user_choice_model.dart';
import 'package:tem_final/src/data/models/user_rating_model.dart';
import 'package:tem_final/src/domain/entities/user_choice_entity.dart';
import 'package:tem_final/src/domain/entities/user_rating_entity.dart';

import '../../domain/entities/user_history_entity.dart';
import '../models/user_history_model.dart';

class UserHistoryMapper implements Mapper<UserHistory, UserHistoryModel> {
  @override
  UserHistoryModel entityToModel(UserHistory entity) {
    return UserHistoryModel(
        idUser: entity.idUser,
        listUserRatings: entity.listUserRatings
            .map((e) => UserRatingModel(
                idTvShowAndMovie: e.idTvShowAndMovie,
                ratingValue: e.ratingValue))
            .toList(),
        listUserChoices: entity.listUserChoices
            .map((e) => UserChoiceModel(
                conclusionSelected: e.conclusionSelected,
                seasonSelected: e.seasonSelected,
                idTvShowAndMovie: e.idTvShowAndMovie))
            .toList(),
        deviceId: entity.deviceId);
  }

  @override
  UserHistory modelToEntity(UserHistoryModel model) {
    return UserHistory(
        idUser: model.idUser,
        listUserRatings: model.listUserRatings
            .map((m) => UserRating(
                idTvShowAndMovie: m.idTvShowAndMovie,
                ratingValue: m.ratingValue))
            .toList(),
        listUserChoices: model.listUserChoices
            .map((m) => UserChoice(
                conclusionSelected: m.conclusionSelected,
                seasonSelected: m.seasonSelected,
                idTvShowAndMovie: m.idTvShowAndMovie))
            .toList(),
        deviceId: model.deviceId);
  }
}
