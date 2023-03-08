import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_image.dart';

class PosterInfo extends StatelessWidget {
  const PosterInfo(
      {super.key,
      required this.tvShowAndMovieInfoStatus,
      this.isMovie = false,
      required this.seasonNumber,
      this.onlySeason = false});

  final TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus;
  final int seasonNumber;
  final bool isMovie;
  final bool onlySeason;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Transform.scale(
            scale: isMovie || onlySeason ? 0.8 : 1,
            child: AspectRatio(
              aspectRatio: tvShowAndMovieInfoStatus.widthPosterImage /
                  tvShowAndMovieInfoStatus.heightPosterImage,
              child: Container(
                  width: tvShowAndMovieInfoStatus.widthPosterImage,
                  height: tvShowAndMovieInfoStatus.heightPosterImage,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CustomImage(
                    urlImage: tvShowAndMovieInfoStatus.posterImageUrl,
                    width: tvShowAndMovieInfoStatus.widthPosterImage,
                    height: tvShowAndMovieInfoStatus.heightPosterImage,
                    fit: BoxFit.fill,
                  )),
            ),
          ),
        ),
        isMovie
            ? Center(child: Container())
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "${Strings.seasonSingularText} $seasonNumber",
                  style: const TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColorGenreMainPage),
                ),
              )
      ],
    );
  }
}
