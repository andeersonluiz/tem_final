import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/entities/user_rating_entity.dart';
import 'package:tem_final/src/domain/usecases/update_tv_show_and_movie_rating_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_user_history_rating_usecase.dart';
import 'package:tem_final/src/presenter/controllers/tv_show_and_movie_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tuple/tuple.dart';

class RatingController extends GetxController {
  RatingController(this._updateUserHistoryRatingUseCase,
      this._updateTvShowAndMovieRatingUseCase);
  final UpdateUserHistoryRatingUseCase _updateUserHistoryRatingUseCase;
  final UpdateTvShowAndMovieRatingUseCase _updateTvShowAndMovieRatingUseCase;
  Rx<StatusRating> statusRating = StatusRating.firstRun.obs;
  Rx<double> ratingValue = 1.0.obs;

  Rx<double> localRating = 0.0.obs;

  Rx<bool> isOpenShowModalBottom = false.obs;

  UserHistoryController userHistoryController =
      Get.find<UserHistoryController>();

  ratingTvShowAndMovie() async {
    TvShowAndMovieController tvShowAndMovieController =
        Get.find<TvShowAndMovieController>();
    statusRating.value = StatusRating.loading;
    print("chamei");
    var resultRatingUserHistory = await _updateUserHistoryRatingUseCase(
        userHistoryController.userHistory.value!);
    print("chamei ${resultRatingUserHistory} ${ratingValue.value.toInt()}");
    var resultRatingTvShowAndMovie = await _updateTvShowAndMovieRatingUseCase(
      Tuple2(tvShowAndMovieController.tvShowAndMovie.value!,
          ratingValue.value.toInt()),
    );

    if (resultRatingTvShowAndMovie is DataSucess &&
        resultRatingUserHistory is DataSucess) {
      tvShowAndMovieController.tvShowAndMovie.value!.isRated = true;
      tvShowAndMovieController.tvShowAndMovie.refresh();
      statusRating.value = StatusRating.sucess;
      localRating.value = ratingValue.value;
      return CustomToast(msg: Strings.ratingSuccessful);
    } else {
      statusRating.value = StatusRating.error;

      return CustomToast(msg: resultRatingTvShowAndMovie.error!.item1);
    }
  }

  _updateLocalRating(double newValue) {
    localRating.value = newValue;
  }

  updateRatingValue(String idTvShowAndMovie, double newValue,
      {bool updateLocalRating = false}) {
    print("updateRatingValue");
    if (statusRating.value == StatusRating.loading) {
      return;
    }
    if (updateLocalRating) {
      _updateLocalRating(newValue);
    }
    ratingValue.value = newValue;
    print("updateRatingValue1 $newValue");
    int index = userHistoryController.userHistory.value!.listUserRatings
        .indexWhere((element) => element.idTvShowAndMovie == idTvShowAndMovie);
    if (index != -1) {
      userHistoryController.userHistory.value!.listUserRatings[index] =
          UserRating(
              idTvShowAndMovie: idTvShowAndMovie,
              ratingValue: ratingValue.value);
    } else {
      userHistoryController.userHistory.value!.listUserRatings.add(UserRating(
          idTvShowAndMovie: idTvShowAndMovie, ratingValue: ratingValue.value));
    }
  }

  updateIsOpenShowModalBottom(bool value) {
    isOpenShowModalBottom.value = value;
  }
}
