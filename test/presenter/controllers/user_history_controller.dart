import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/entities/user_rating_entity.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_user_history_rating_usecase.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';

import '../../domain/usecases/get_local_user_history_usecase.dart';
import '../../domain/usecases/rating_tv_show_and_movie_usecase.dart';

class MockUserHistoryController extends GetxController {
  MockUserHistoryController(
      this._getLocalUserHistoryUseCase, this._ratingTvShowAndMovieUseCase);
  final MockGetLocalUserHistoryUseCase _getLocalUserHistoryUseCase;
  final MockRatingTvShowAndMovieUseCase _ratingTvShowAndMovieUseCase;
  Rxn<UserHistory> userHistory = Rxn<UserHistory>();
  Rx<String> errorLoadUserHistory = "".obs;
  Rx<StatusRating> statusRating = StatusRating.firstRun.obs;
  Rx<double> ratingValue = 1.0.obs;

  Future<void> getLocalUserHistory() async {
    statusRating.value = StatusRating.loading;
    var resultGetLocalUserHistory = await _getLocalUserHistoryUseCase();

    if (resultGetLocalUserHistory is DataSucess) {
      print("carreguei");
      userHistory.value = resultGetLocalUserHistory.data;
      print(userHistory.value);
      statusRating.value = StatusRating.sucess;
    } else {
      print("n carreguei");
      errorLoadUserHistory.value = resultGetLocalUserHistory.error!.item1;
      statusRating.value = StatusRating.error;
    }
  }

  ratingTvShowAndMovie() async {
    statusRating.value = StatusRating.loading;
    var resultRatingTvShowAndMovie =
        await _ratingTvShowAndMovieUseCase(userHistory.value!);
    if (resultRatingTvShowAndMovie is DataSucess) {
      statusRating.value = StatusRating.sucess;

      return CustomToast(msg: Strings.ratingSuccessful);
    } else {
      statusRating.value = StatusRating.error;

      return CustomToast(msg: resultRatingTvShowAndMovie.error!.item1);
    }
  }

  updateRatingValue(String idTvShowAndMovie, double newValue) {
    print("Ooi $idTvShowAndMovie $newValue");
    int index = userHistory.value!.listUserRatings
        .indexWhere((element) => element.idTvShowAndMovie == idTvShowAndMovie);
    print("Index $index");
    if (index != -1) {
      userHistory.value!.listUserRatings[index] = UserRating(
          idTvShowAndMovie: idTvShowAndMovie, ratingValue: ratingValue.value);
    } else {
      userHistory.value!.listUserRatings.add(UserRating(
          idTvShowAndMovie: idTvShowAndMovie, ratingValue: ratingValue.value));
    }

    ratingValue.value = newValue;
  }
}
