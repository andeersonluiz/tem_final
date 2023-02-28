import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/presenter/pages/search/widgets/search_item.dart';
import 'package:tem_final/src/presenter/reusableWidgets/empty_list_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/error_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/favorite/favorite_state.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_state.dart';

class SearchPage extends SearchDelegate {
  SearchPage(this.searchBloc, this.favoriteBloc);
  final SearchBloc searchBloc;
  final FavoriteBloc favoriteBloc;
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(color: appBarColor),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: ratingColorPosterMainPage),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          color: Colors.white70,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        return IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () async {
            if (state is! SearchLoading) {
              query = "";
              searchBloc.add(GetRecentsEvent(query: query));

              FocusScope.of(context).unfocus();
            }
          },
        );
      })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(SearchQueryEvent(query: query));

    return Container(
      color: backgroundColor,
      width: 100.h,
      height: 100.h,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CustomLoadingWidget());
          } else if (state is SearchEmpty) {
            return EmptyListWidget(msg: state.notFoundList);
          } else if (state is SearchDone) {
            return ScrollConfiguration(
                behavior: MyBehavior(),
                child: BlocBuilder<FavoriteBloc, FavoriteState>(
                    builder: (context, stateFavorite) {
                  return ListView.builder(
                    itemCount: state.queryResultList.length,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          searchBloc.add(SetRecentsEvent(
                              query: query,
                              tvShowAndMovie: state.queryResultList[index]));
                          Navigator.of(context)
                              .pushNamed(Routes.info, arguments: {
                            "title": state.queryResultList[index].title,
                            "idTvShowAndMovie": state.queryResultList[index].id
                          });
                        },
                        child: SearchItem(
                          tvShowAndMovieItem: state.queryResultList[index],
                          favoriteBloc: favoriteBloc,
                          isFavorite: stateFavorite.favoriteList
                              .contains(state.queryResultList[index]),
                        ),
                      );
                    },
                  );
                }));
          } else {
            CustomToast(msg: state.errorMsg.toString());
            return Container();
          }
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc.add(SearchQueryEvent(query: query));
      searchBloc.add(ShowFakeLoadingEvent(query: query));
    } else {
      searchBloc.add(GetRecentsEvent(query: query));
    }
    return Container(
      color: backgroundColor,
      width: 100.h,
      height: 100.h,
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CustomLoadingWidget());
          } else if (state is SearchEmpty) {
            return EmptyListWidget(msg: state.notFoundList);
          } else if (state is SearchDone) {
            return BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, stateFavorite) {
              if (stateFavorite is FavoriteError) {
                favoriteBloc.add(ResetFavoriteEvent());
              }
              if (stateFavorite is FavoriteToastDone) {
                if (stateFavorite.isFavorite) {
                  CustomToast(msg: stateFavorite.msg);
                }
                favoriteBloc.add(UpdateFavoriteEvent());
              }
              return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.builder(
                    itemCount: state.queryResultList.length,
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16.0, left: 16.0, bottom: 8.0),
                                child: Text(
                                  state.header!,
                                  style: const TextStyle(
                                      fontFamily: fontFamily,
                                      color: ratingColorPosterMainPage,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  searchBloc.add(SetRecentsEvent(
                                      query: query,
                                      tvShowAndMovie:
                                          state.queryResultList[index]));
                                  Navigator.of(context)
                                      .pushNamed(Routes.info, arguments: {
                                    "title": state.queryResultList[index].title,
                                    "idTvShowAndMovie":
                                        state.queryResultList[index].id
                                  });
                                },
                                child: SearchItem(
                                  tvShowAndMovieItem:
                                      state.queryResultList[index],
                                  favoriteBloc: favoriteBloc,
                                  isFavorite: stateFavorite.favoriteList
                                      .contains(state.queryResultList[index]),
                                ),
                              )
                            ]);
                      }
                      return GestureDetector(
                        onTap: () {
                          searchBloc.add(SetRecentsEvent(
                              query: query,
                              tvShowAndMovie: state.queryResultList[index]));
                          Navigator.of(context)
                              .pushNamed(Routes.info, arguments: {
                            "title": state.queryResultList[index].title,
                            "idTvShowAndMovie": state.queryResultList[index].id
                          });
                        },
                        child: SearchItem(
                          tvShowAndMovieItem: state.queryResultList[index],
                          favoriteBloc: favoriteBloc,
                          isFavorite: stateFavorite.favoriteList
                              .contains(state.queryResultList[index]),
                        ),
                      );
                    },
                  ));
            });
          } else {
            CustomToast(msg: state.errorMsg.toString());
            return Container();
          }
        },
      ),
    );
  }

  @override
  void showSuggestions(BuildContext context) {}

  @override
  void showResults(BuildContext context) {}

  @override
  String get searchFieldLabel => 'Buscar títulos';
}
