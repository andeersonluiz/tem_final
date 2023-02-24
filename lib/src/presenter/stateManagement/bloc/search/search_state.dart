// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class SearchState extends Equatable {
  final List<TvShowAndMovie> queryResultList;
  final String notFoundList;
  final String? errorMsg;
  final String? header;
  const SearchState(
      {required this.queryResultList,
      required this.notFoundList,
      this.errorMsg,
      this.header});

  @override
  List<Object> get props => [queryResultList, notFoundList, errorMsg ?? ""];
}

class SearchLoading extends SearchState {
  const SearchLoading(
      {required super.queryResultList, required super.notFoundList});
}

class SearchEmpty extends SearchState {
  const SearchEmpty(
      {required super.queryResultList, required super.notFoundList});
}

class SearchDone extends SearchState {
  const SearchDone(
      {required super.queryResultList,
      required super.notFoundList,
      required super.header});
}

class SearchError extends SearchState {
  const SearchError(
      {required super.queryResultList,
      required super.notFoundList,
      required super.errorMsg});
}
