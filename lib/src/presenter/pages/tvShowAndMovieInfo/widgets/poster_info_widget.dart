import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_image.dart';

class PosterInfo extends StatelessWidget {
  const PosterInfo(
      {super.key,
      required this.tvShowAndMovieInfoStatus,
      this.isMovie = false,
      required this.seasonNumber});

  final TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus;
  final int seasonNumber;
  final bool isMovie;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
              width: WidgetSize.widthPosterInfoPage,
              height: WidgetSize.heightPosterInfoPage,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CustomImage(
                width: WidgetSize.widthPosterInfoPage,
                urlImage: tvShowAndMovieInfoStatus.posterImageUrl,
                height: WidgetSize.heightPosterInfoPage,
                fit: BoxFit.contain,
              )),
        ),
        isMovie
            ? Center(child: Container())
            : Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "${Strings.seasonSingularText} $seasonNumber",
                    style: const TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColorGenreMainPage),
                  ),
                ),
              )
      ],
    );
  }
}
