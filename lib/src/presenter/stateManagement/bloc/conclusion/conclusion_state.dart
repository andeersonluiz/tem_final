// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';

class ConclusionState extends Equatable {
  const ConclusionState(
      {this.conclusion,
      this.conclusionHasFinal,
      this.conclusionNoHasFinal,
      this.showAnimation,
      required this.conclusionSelectionStatus,
      this.tvShowAndMovie,
      this.msg});
  final Conclusion? conclusion;
  final ConclusionHasFinal? conclusionHasFinal;
  final ConclusionNoHasFinal? conclusionNoHasFinal;
  final bool? showAnimation;
  final ConclusionSelectionStatus conclusionSelectionStatus;
  final String? msg;
  final TvShowAndMovie? tvShowAndMovie;
  @override
  List<Object> get props => [
        conclusion ?? "",
        conclusionHasFinal ?? "",
        conclusionNoHasFinal ?? "",
        showAnimation ?? "",
        tvShowAndMovie ?? "",
        conclusionSelectionStatus,
        msg ?? ""
      ];
}

class LoadingConclusion extends ConclusionState {
  const LoadingConclusion({required super.conclusionSelectionStatus});
}

class NoSelectConclusion extends ConclusionState {
  const NoSelectConclusion({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required TvShowAndMovie tvShowAndMovie,
  }) : super(
            conclusion: null,
            conclusionHasFinal: null,
            conclusionNoHasFinal: null,
            conclusionSelectionStatus: conclusionSelectionStatus,
            tvShowAndMovie: tvShowAndMovie);
}

class SelectFirstConclusion extends ConclusionState {
  const SelectFirstConclusion(
      {Conclusion? conclusion,
      bool? showAnimation,
      required ConclusionSelectionStatus conclusionSelectionStatus,
      required TvShowAndMovie tvShowAndMovie})
      : super(
            conclusion: conclusion,
            showAnimation: showAnimation,
            conclusionSelectionStatus: conclusionSelectionStatus,
            tvShowAndMovie: tvShowAndMovie);
}

class SelectSecondConclusion extends ConclusionState {
  SelectSecondConclusion(
      {required Conclusion conclusion,
      ConclusionHasFinal? conclusionHasFinal,
      ConclusionNoHasFinal? conclusionNoHasFinal,
      required ConclusionSelectionStatus conclusionSelectionStatus,
      required TvShowAndMovie tvShowAndMovie})
      : super(
            conclusion: conclusion,
            conclusionHasFinal: conclusionHasFinal,
            conclusionNoHasFinal: conclusionNoHasFinal,
            conclusionSelectionStatus: conclusionSelectionStatus,
            tvShowAndMovie: tvShowAndMovie) {
    if ((conclusionHasFinal != null && conclusionNoHasFinal != null) ||
        (conclusionHasFinal == null && conclusionNoHasFinal == null)) {
      throw ArgumentError('At least one parameter must be provided.');
    }
  }
}

class SelectConclusionDone extends ConclusionState {
  const SelectConclusionDone({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required String msg,
    required TvShowAndMovie tvShowAndMovie,
  }) : super(
          conclusionSelectionStatus: conclusionSelectionStatus,
          msg: msg,
          tvShowAndMovie: tvShowAndMovie,
        );
}

class SelectConclusionError extends ConclusionState {
  const SelectConclusionError({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required TvShowAndMovie tvShowAndMovie,
    required String msg,
  }) : super(
            conclusionSelectionStatus: conclusionSelectionStatus,
            msg: msg,
            tvShowAndMovie: tvShowAndMovie);
}

class ConclusionResults extends ConclusionState {
  const ConclusionResults(
      {required TvShowAndMovie tvShowAndMovie,
      required ConclusionSelectionStatus conclusionSelectionStatus})
      : super(
            tvShowAndMovie: tvShowAndMovie,
            conclusionSelectionStatus: conclusionSelectionStatus);
}

class Unauthorized extends ConclusionState {
  const Unauthorized({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required String msg,
    required TvShowAndMovie tvShowAndMovie,
  }) : super(
            conclusionSelectionStatus: conclusionSelectionStatus,
            msg: msg,
            tvShowAndMovie: tvShowAndMovie);
}

class ConclusionSelectionStatus extends Equatable {
  const ConclusionSelectionStatus({
    required this.hasSelectedFirstConclusion,
    required this.hasSelectedSecondConclusion,
    required this.bothConclusionSelected,
    required this.showAnimationOpacitySecondConclusion,
    required this.showButton,
  });
  final bool hasSelectedFirstConclusion;
  final bool hasSelectedSecondConclusion;
  final bool bothConclusionSelected;
  final bool showAnimationOpacitySecondConclusion;
  final bool showButton;
  @override
  String toString() {
    return 'ConclusionSelectionStatus(hasSelectedFirstConclusion: $hasSelectedFirstConclusion, hasSelectedSecondConclusion: $hasSelectedSecondConclusion, bothConclusionSelected: $bothConclusionSelected, showAnimationOpacitySecondConclusion: $showAnimationOpacitySecondConclusion)';
  }

  @override
  List<Object> get props {
    return [
      hasSelectedFirstConclusion,
      hasSelectedSecondConclusion,
      bothConclusionSelected,
      showAnimationOpacitySecondConclusion,
      showButton,
    ];
  }

  ConclusionSelectionStatus copyWith({
    bool? hasSelectedFirstConclusion,
    bool? hasSelectedSecondConclusion,
    bool? bothConclusionSelected,
    bool? showAnimationOpacitySecondConclusion,
    bool? showButton,
  }) {
    return ConclusionSelectionStatus(
      hasSelectedFirstConclusion:
          hasSelectedFirstConclusion ?? this.hasSelectedFirstConclusion,
      hasSelectedSecondConclusion:
          hasSelectedSecondConclusion ?? this.hasSelectedSecondConclusion,
      bothConclusionSelected:
          bothConclusionSelected ?? this.bothConclusionSelected,
      showAnimationOpacitySecondConclusion:
          showAnimationOpacitySecondConclusion ??
              this.showAnimationOpacitySecondConclusion,
      showButton: showButton ?? this.showButton,
    );
  }

  @override
  bool get stringify => true;
}
