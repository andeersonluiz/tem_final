// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TvShowAndMovieInfoStatus extends Equatable {
  final int seasonNumber;
  final int hasFinalAndOpened;
  final int hasFinalAndClosed;
  final int noHasfinalAndNewSeason;
  final int noHasfinalAndNoNewSeason;
  final String posterImageUrl;
  const TvShowAndMovieInfoStatus({
    required this.seasonNumber,
    required this.hasFinalAndOpened,
    required this.hasFinalAndClosed,
    required this.noHasfinalAndNewSeason,
    required this.noHasfinalAndNoNewSeason,
    required this.posterImageUrl,
  });

  @override
  List<Object> get props {
    return [
      seasonNumber,
      hasFinalAndOpened,
      hasFinalAndClosed,
      noHasfinalAndNewSeason,
      noHasfinalAndNoNewSeason,
      posterImageUrl,
    ];
  }
}
