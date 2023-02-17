import 'package:equatable/equatable.dart';

abstract class TvShowAndMovieInfoEvent extends Equatable {
  const TvShowAndMovieInfoEvent({required this.id});
  final String id;

  @override
  List<Object> get props => [id];
}

class GetTvShowAndMovieEvent extends TvShowAndMovieInfoEvent {
  const GetTvShowAndMovieEvent(String id) : super(id: id);
}
