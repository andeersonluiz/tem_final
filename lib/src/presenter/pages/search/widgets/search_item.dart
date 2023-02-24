import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/icons.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/pages/search/widgets/icon_rounded.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_image.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';

import '../../../stateManagement/bloc/favorite/favorite_bloc.dart';
import '../../../stateManagement/bloc/favorite/favorite_state.dart';

class SearchItem extends StatelessWidget {
  const SearchItem(
      {super.key,
      required this.tvShowAndMovieItem,
      required this.favoriteBloc,
      required this.isFavorite});
  final TvShowAndMovie tvShowAndMovieItem;
  final FavoriteBloc favoriteBloc;
  final bool isFavorite;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: WidgetSize.heightCard,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.grey,
        color: backgroundColor,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  color: Colors.green,
                  child: CustomImage(
                    urlImage: tvShowAndMovieItem.posterImage,
                    height: WidgetSize.heightCard,
                    fit: BoxFit.fill,
                  ),
                )),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 16.0, bottom: 8.0),
                          child: Text(
                            tvShowAndMovieItem.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontFamily: fontFamily,
                                fontSize: kSizeTitleCard,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            favoriteBloc.add(SetFavoriteEvent(
                                tvShowAndMovie: tvShowAndMovieItem));
                          },
                          icon: isFavorite
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                ))
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildWidgetByStatus(tvShowAndMovieItem),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12),
                    child: RatingBarIndicator(
                      rating: tvShowAndMovieItem.averageRating.toDouble(),
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: const EdgeInsets.symmetric(vertical: 4.0),
                      unratedColor: unratedColorPosterMainPage,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: ratingColorPosterMainPage,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildWidgetByStatus(TvShowAndMovie tvShowAndMovie) {
    if (tvShowAndMovie.countConclusion < minCountConclusion) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: IconRounded(
            icon: Icon(
              Icons.remove,
              color: Colors.white,
              size: kIconSizeCard,
            ),
            text: Strings.noEnoughData,
            backgroundColor: Colors.grey),
      );
    }
    ConclusionType conclusionType = tvShowAndMovie.actualStatus;
    switch (conclusionType) {
      case ConclusionType.hasFinalAndOpened:
        return const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    hasFinalIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.hasFinalOptionText,
                  backgroundColor: hasFinalColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    openedIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.openedOptionText,
                  backgroundColor: openedColor),
            ),
          ],
        );
      case ConclusionType.hasFinalAndClosed:
        return const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    hasFinalIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.hasFinalOptionText,
                  backgroundColor: hasFinalColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    closedIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.closedOptionText,
                  backgroundColor: closedColor),
            ),
          ],
        );
      case ConclusionType.noHasfinalAndNewSeason:
        return const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    noHasFinalIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.noHasFinalOptionText,
                  backgroundColor: noHasFinalColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    newSeasonIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.newSeasonOptionText,
                  backgroundColor: newSeasonColor),
            ),
          ],
        );
      case ConclusionType.noHasfinalAndNoNewSeason:
        return const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    noHasFinalIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.noHasFinalOptionText,
                  backgroundColor: noHasFinalColor),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
              child: IconRounded(
                  icon: Icon(
                    noNewSeasonIcon,
                    color: Colors.white,
                    size: kIconSizeCard,
                  ),
                  text: Strings.noNewSeasonOptionText,
                  backgroundColor: noNewSeasonColor),
            ),
          ],
        );
    }
  }
}
