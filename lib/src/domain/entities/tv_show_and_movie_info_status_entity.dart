// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class TvShowAndMovieInfoStatus extends Equatable {
  final int seasonNumber;
  final int conclusiveCount;
  final int openEndedCount;
  final int unknownCount;
  final String posterImageUrl;
  const TvShowAndMovieInfoStatus({
    required this.seasonNumber,
    required this.conclusiveCount,
    required this.openEndedCount,
    required this.unknownCount,
    required this.posterImageUrl,
  });

  @override
  List<Object> get props {
    return [
      seasonNumber,
      conclusiveCount,
      openEndedCount,
      unknownCount,
      posterImageUrl,
    ];
  }
}
