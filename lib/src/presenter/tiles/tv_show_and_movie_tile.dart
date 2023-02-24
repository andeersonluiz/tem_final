import 'package:flutter/material.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_image.dart';

class TvShowAndMovieTile extends StatelessWidget {
  const TvShowAndMovieTile({super.key, required this.tvShowAndMovie});

  final TvShowAndMovie tvShowAndMovie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
      height: WidgetSize.heightPoster,
      width: WidgetSize.widthPoster,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: CustomImage(
            urlImage: tvShowAndMovie.posterImage,
          )),
          const SizedBox(
            height: 7,
          ),
          Text(
            tvShowAndMovie.title,
            style: const TextStyle(
                fontFamily: fontFamily,
                fontSize: 14,
                color: textColorPosterMainPage,
                overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
          RatingBarIndicator(
            rating: tvShowAndMovie.averageRating,
            direction: Axis.horizontal,
            itemCount: 5,
            itemSize: 15,
            itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
            unratedColor: unratedColorPosterMainPage,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: ratingColorPosterMainPage,
            ),
          ),
        ],
      ),
    );
  }
}
