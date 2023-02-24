import 'package:equatable/equatable.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class ConclusionEvent extends Equatable {
  const ConclusionEvent({
    this.conclusion,
    this.conclusionHasFinal,
    this.conclusionNoHasFinal,
    this.tvShowAndMovie,
  });
  final Conclusion? conclusion;
  final ConclusionHasFinal? conclusionHasFinal;
  final ConclusionNoHasFinal? conclusionNoHasFinal;
  final TvShowAndMovie? tvShowAndMovie;
  @override
  List<Object> get props => [
        conclusion ?? "",
        conclusionHasFinal ?? "",
        conclusionNoHasFinal ?? "",
        tvShowAndMovie ?? ""
      ];
}

class SelectFirstConclusionEvent extends ConclusionEvent {
  const SelectFirstConclusionEvent(
    Conclusion conclusion,
  ) : super(
          conclusion: conclusion,
        );
}

class BackConclusionEvent extends ConclusionEvent {
  const BackConclusionEvent(Conclusion? conclusion)
      : super(conclusion: conclusion);
}

class ShowAnimation extends ConclusionEvent {
  const ShowAnimation(Conclusion? conclusion) : super(conclusion: conclusion);
}

class SelectSecondConclusionEvent extends ConclusionEvent {
  SelectSecondConclusionEvent(
      {required Conclusion conclusion,
      ConclusionHasFinal? conclusionHasFinal,
      ConclusionNoHasFinal? conclusionNoHasFinal})
      : super(
            conclusion: conclusion,
            conclusionHasFinal: conclusionHasFinal,
            conclusionNoHasFinal: conclusionNoHasFinal) {
    if ((conclusionHasFinal != null && conclusionNoHasFinal != null) ||
        (conclusionHasFinal == null && conclusionNoHasFinal == null)) {
      throw ArgumentError('At least one parameter must be provided.');
    }
  }
}

class SendConclusionEvent extends ConclusionEvent {
  const SendConclusionEvent({
    required TvShowAndMovie tvShowAndMovie,
  }) : super(tvShowAndMovie: tvShowAndMovie);
}

class ResetConclusionEvent extends ConclusionEvent {}

class ShowResultsEvent extends ConclusionEvent {
  const ShowResultsEvent({
    required TvShowAndMovie tvShowAndMovie,
  }) : super(tvShowAndMovie: tvShowAndMovie);
}
