import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';

abstract class TvShowAndMovieEvent extends Equatable {
  const TvShowAndMovieEvent(
      {required this.filterSelected, this.refresh = false});
  final String filterSelected;
  final bool refresh;
  @override
  List<Object> get props => [filterSelected];
}

class GetAllTvShowAndMovieEvent extends TvShowAndMovieEvent {
  GetAllTvShowAndMovieEvent(Filter filter, {bool refresh = false})
      : super(filterSelected: filter.string, refresh: refresh);
}

class GetAllTvShowEvent extends TvShowAndMovieEvent {
  GetAllTvShowEvent(Filter filter) : super(filterSelected: filter.string);
}

class GetAllMovieEvent extends TvShowAndMovieEvent {
  GetAllMovieEvent(Filter filter) : super(filterSelected: filter.string);
}

class LoadingMoreEvent extends TvShowAndMovieEvent {
  LoadingMoreEvent(Filter filter) : super(filterSelected: filter.string);
}
