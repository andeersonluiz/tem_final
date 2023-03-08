// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TvShowAndMovieInfoStatus extends Equatable {
  final int seasonNumber;
  final int hasFinalAndOpened;
  final int hasFinalAndClosed;
  final int noHasfinalAndNewSeason;
  final int noHasfinalAndNoNewSeason;
  final String posterImageUrl;
  double widthPosterImage;
  double heightPosterImage;
  TvShowAndMovieInfoStatus({
    required this.seasonNumber,
    required this.hasFinalAndOpened,
    required this.hasFinalAndClosed,
    required this.noHasfinalAndNewSeason,
    required this.noHasfinalAndNoNewSeason,
    required this.posterImageUrl,
    this.widthPosterImage = 0,
    this.heightPosterImage = 0,
  });

  @override
  List<Object> get props {
    return [
      seasonNumber,
    ];
  }
}
