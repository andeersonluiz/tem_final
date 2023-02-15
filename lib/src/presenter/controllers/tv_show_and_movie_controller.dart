// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_all_movie_usecase.dart';

import 'package:tem_final/src/domain/usecases/get_all_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_all_tv_show_usecase.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/domain/usecases/load_more_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/analytics_controller.dart';
import 'package:tem_final/src/presenter/controllers/rating_controller.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';
import 'package:tuple/tuple.dart';

class TvShowAndMovieController extends GetxController {
  TvShowAndMovieController(
    this._getTvShowAndMovieUseCase,
  );

  final GetTvShowAndMovieUseCase _getTvShowAndMovieUseCase;
  Rxn<TvShowAndMovie> tvShowAndMovie = Rxn<TvShowAndMovie>();
  Rx<StatusLoadingOnlyTvShowAndMovie> statusLoadingOnlyTvShowAndMovie =
      StatusLoadingOnlyTvShowAndMovie.firstRun.obs;
  Rx<String> errorTvShowAndMovie = "".obs;
  //final List<Size> listImageSizes = [];
  RatingController ratingController = Get.find<RatingController>();
  AnalyticsController analyticsController = Get.find<AnalyticsController>();
  UserHistoryController userHistoryController =
      Get.find<UserHistoryController>();
  getTvShowAndMovie(String id) async {
    Future.microtask(() {
      statusLoadingOnlyTvShowAndMovie.value =
          StatusLoadingOnlyTvShowAndMovie.loading;
    });

    var resultTvShowAndMovie = await _getTvShowAndMovieUseCase(id);
    await analyticsController.updateViewCount(id);
    if (resultTvShowAndMovie is DataSucess) {
      if (resultTvShowAndMovie.data!.id.isEmpty) {
        errorTvShowAndMovie.value = Strings.tvShowAndNotFound;
        statusLoadingOnlyTvShowAndMovie.value =
            StatusLoadingOnlyTvShowAndMovie.error;
      } else {
        /*for (TvShowAndMovieInfoStatus item in resultTvShowAndMovie
            .data!.listTvShowAndMovieInfoStatusBySeason) {
          var imageSize = await _calculateImageDimension(item.posterImageUrl);
          listImageSizes.add(imageSize);
        }*/
        tvShowAndMovie.value = resultTvShowAndMovie.data;
        updateUserRepositoryData(id);
        statusLoadingOnlyTvShowAndMovie.value =
            StatusLoadingOnlyTvShowAndMovie.sucess;
      }
    } else {
      errorTvShowAndMovie.value = resultTvShowAndMovie.error!.item1;
      statusLoadingOnlyTvShowAndMovie.value =
          StatusLoadingOnlyTvShowAndMovie.error;
    }
  }

  Future<Size> _calculateImageDimension(String url) {
    Completer<Size> completer = Completer();
    Image image = Image.network(url);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  Future<void> updateUserRepositoryData(String idTvShowAndMovie) async {
    await userHistoryController.getLocalUserHistory();
    int index = userHistoryController.userHistory.value!.listUserRatings
        .indexWhere((element) => element.idTvShowAndMovie == idTvShowAndMovie);
    if (index != -1) {
      tvShowAndMovie.value!.isRated = true;
      ratingController.updateRatingValue(
          idTvShowAndMovie,
          userHistoryController
              .userHistory.value!.listUserRatings[index].ratingValue,
          updateLocalRating: true);
    }
  }
}
