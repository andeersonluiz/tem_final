import 'package:equatable/equatable.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class FavoriteState extends Equatable {
  const FavoriteState(
      {required this.favoriteList,
      required this.msg,
      required this.isFavorite});
  final List<TvShowAndMovie> favoriteList;
  final String msg;
  final bool isFavorite;
  @override
  List<Object> get props => [favoriteList, msg, isFavorite];
}

class FavoriteDone extends FavoriteState {
  const FavoriteDone(
      {required super.favoriteList,
      required super.msg,
      required super.isFavorite});
}

class FavoriteLoading extends FavoriteState {
  const FavoriteLoading(
      {required super.favoriteList,
      required super.msg,
      required super.isFavorite});
}

class FavoriteError extends FavoriteState {
  const FavoriteError(
      {required super.favoriteList,
      required super.msg,
      required super.isFavorite});
}
