import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/core/utils/widget_size.dart';
import 'package:tem_final/src/presenter/tiles/tv_show_and_movie_tile.dart';
import 'package:tuple/tuple.dart';

import '../../../../domain/entities/tv_show_and_movie_entity.dart';

class ListTvShowAndMovie extends StatelessWidget {
  const ListTvShowAndMovie(this.listTvShowAndMovie, this.controller,
      {super.key});
  final ScrollController controller;
  final List<Tuple2<GenreType, List<TvShowAndMovie>>> listTvShowAndMovie;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: MyBehavior(),
        child: ListView.builder(
            controller: controller,
            itemCount: listTvShowAndMovie.length,
            itemBuilder: (ctx, index) {
              if (listTvShowAndMovie[index].item1.string.isNotEmpty) {
                Tuple2<GenreType, List<TvShowAndMovie>> tuple =
                    listTvShowAndMovie[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: SizedBox(
                    height: WidgetSize.sizeSectionGenre,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(Routes.genre,
                                arguments: {
                                  "index": tuple.item1.index.toString()
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(
                              12.0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    tuple.item1.string,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: fontFamily,
                                        color: textColorGenreMainPage,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: textColorGenreMainPage,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: tuple.item2
                                .map((item) => GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed(Routes.info, arguments: {
                                          "title": item.title,
                                          "idTvShowAndMovie": item.id
                                        });
                                      },
                                      child: TvShowAndMovieTile(
                                        tvShowAndMovie: item,
                                      ),
                                    ))
                                .toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }));
  }
}
