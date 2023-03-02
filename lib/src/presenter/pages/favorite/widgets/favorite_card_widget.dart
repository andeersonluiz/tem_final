import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_image.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';

import '../../../stateManagement/bloc/favorite/favorite_bloc.dart';

class FavoriteCard extends StatelessWidget {
  const FavoriteCard(
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
      height: WidgetSize.heightCardFavoritePage,
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shadowColor: Colors.grey,
        color: backgroundColor,
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: CustomImage(
                  urlImage: tvShowAndMovieItem.posterImage,
                  height: WidgetSize.heightCardFavoritePage,
                  fit: BoxFit.fill,
                )),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
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
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            CustomToast(msg: "Removido com sucesso");
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
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
