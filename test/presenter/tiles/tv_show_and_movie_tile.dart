import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class TvShowAndMovieTile extends StatelessWidget {
  const TvShowAndMovieTile({super.key, required this.tvShowAndMovie});

  final TvShowAndMovie tvShowAndMovie;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(tvShowAndMovie.posterImage),
        Text(tvShowAndMovie.title),
        Text(tvShowAndMovie.imdbInfo.rating.toString()),
      ],
    );
  }
}
