import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/domain/usecases/get_tv_show_and_movie_usecase.dart';
import 'package:tem_final/src/presenter/controllers/user_history_controller.dart';
import 'package:tuple/tuple.dart';

import '../../domain/usecases/get_tv_show_and_movie_usecase_test.dart';
import 'user_history_controller.dart';

class MockTvShowAndMovieController extends GetxController {
  MockTvShowAndMovieController(
    this._getTvShowAndMovieUseCase,
  );

  final MockGetTvShowAndMovieUseCase _getTvShowAndMovieUseCase;
  Rxn<TvShowAndMovie> tvShowAndMovie = Rxn<TvShowAndMovie>();
  Rx<StatusLoadingOnlyTvShowAndMovie> statusLoadingOnlyTvShowAndMovie =
      StatusLoadingOnlyTvShowAndMovie.firstRun.obs;
  Rx<String> errorTvShowAndMovie = "".obs;
  //final List<Size> listImageSizes = [];
  MockUserHistoryController userHistoryController =
      Get.find<MockUserHistoryController>();
  getTvShowAndMovie(String id) async {
    Future.microtask(() {
      statusLoadingOnlyTvShowAndMovie.value =
          StatusLoadingOnlyTvShowAndMovie.loading;
    });

    await Future.delayed(Duration(seconds: 2));
    var resultTvShowAndMovie = await _getTvShowAndMovieUseCase(id);
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
        await userHistoryController.getLocalUserHistory();
        int index = userHistoryController.userHistory.value!.listUserRatings
            .indexWhere((element) => element.idTvShowAndMovie == id);
        print("index $index $id");
        print(userHistoryController.userHistory.value!.listUserRatings);
        if (index != -1) {
          tvShowAndMovie.value!.isRated = true;
          userHistoryController.updateRatingValue(
              id,
              userHistoryController
                  .userHistory.value!.listUserRatings[index].ratingValue);
        }
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
}
