// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import 'package:tem_final/src/core/utils/constants.dart';

class GenreEvent extends Equatable {
  final GenreType? genreType;
  final Tuple2<Filter, FilterGenre>? filters;

  const GenreEvent({
    this.genreType,
    this.filters,
  });

  @override
  List<Object> get props => [genreType ?? "", filters ?? ""];
}

class GetGenreEvent extends GenreEvent {
  const GetGenreEvent({
    required super.genreType,
    required super.filters,
  });
}

class FilterGenreEvent extends GenreEvent {
  const FilterGenreEvent({required super.genreType, required super.filters});
}

class LoadMoreGenreEvent extends GenreEvent {
  const LoadMoreGenreEvent();
}
