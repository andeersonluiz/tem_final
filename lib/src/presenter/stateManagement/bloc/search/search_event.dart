// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class SearchEvent extends Equatable {
  final String query;
  final TvShowAndMovie? tvShowAndMovie;
  final bool refresh;
  const SearchEvent(
      {required this.query, this.tvShowAndMovie, this.refresh = false});

  @override
  List<Object> get props => [query];
}

class SearchQueryEvent extends SearchEvent {
  const SearchQueryEvent({
    required super.query,
    super.refresh,
  });
}

class GetRecentsEvent extends SearchEvent {
  const GetRecentsEvent({
    required super.query,
  });
}

class SetRecentsEvent extends SearchEvent {
  const SetRecentsEvent({
    required super.query,
    required super.tvShowAndMovie,
  });
}

class ShowFakeLoadingEvent extends SearchEvent {
  const ShowFakeLoadingEvent({
    required super.query,
  });
}
