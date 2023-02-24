// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_info_status_entity.dart';

class ConclusionState extends Equatable {
  const ConclusionState(
      {this.conclusion,
      this.conclusionHasFinal,
      this.conclusionNoHasFinal,
      this.showAnimation,
      required this.conclusionSelectionStatus,
      this.tvShowAndMovieInfoStatus,
      this.msg});
  final Conclusion? conclusion;
  final ConclusionHasFinal? conclusionHasFinal;
  final ConclusionNoHasFinal? conclusionNoHasFinal;
  final bool? showAnimation;
  final ConclusionSelectionStatus conclusionSelectionStatus;
  final String? msg;
  final TvShowAndMovieInfoStatus? tvShowAndMovieInfoStatus;
  @override
  List<Object> get props => [
        conclusion ?? "",
        conclusionHasFinal ?? "",
        conclusionNoHasFinal ?? "",
        showAnimation ?? "",
        tvShowAndMovieInfoStatus ?? "",
        conclusionSelectionStatus,
        msg ?? ""
      ];
}

class NoSelectConclusion extends ConclusionState {
  const NoSelectConclusion({
    required ConclusionSelectionStatus conclusionSelectionStatus,
  }) : super(
          conclusion: null,
          conclusionHasFinal: null,
          conclusionNoHasFinal: null,
          conclusionSelectionStatus: conclusionSelectionStatus,
        );
}

class SelectFirstConclusion extends ConclusionState {
  const SelectFirstConclusion({
    Conclusion? conclusion,
    bool? showAnimation,
    required ConclusionSelectionStatus conclusionSelectionStatus,
  }) : super(
          conclusion: conclusion,
          showAnimation: showAnimation,
          conclusionSelectionStatus: conclusionSelectionStatus,
        );
}

class SelectSecondConclusion extends ConclusionState {
  SelectSecondConclusion({
    required Conclusion conclusion,
    ConclusionHasFinal? conclusionHasFinal,
    ConclusionNoHasFinal? conclusionNoHasFinal,
    required ConclusionSelectionStatus conclusionSelectionStatus,
  }) : super(
          conclusion: conclusion,
          conclusionHasFinal: conclusionHasFinal,
          conclusionNoHasFinal: conclusionNoHasFinal,
          conclusionSelectionStatus: conclusionSelectionStatus,
        ) {
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
  }) : super(conclusionSelectionStatus: conclusionSelectionStatus, msg: msg);
}

class SelectConclusionError extends ConclusionState {
  const SelectConclusionError({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required String msg,
  }) : super(conclusionSelectionStatus: conclusionSelectionStatus, msg: msg);
}

class ConclusionResults extends ConclusionState {
  const ConclusionResults(
      {required TvShowAndMovieInfoStatus tvShowAndMovieInfoStatus,
      required ConclusionSelectionStatus conclusionSelectionStatus})
      : super(
            tvShowAndMovieInfoStatus: tvShowAndMovieInfoStatus,
            conclusionSelectionStatus: conclusionSelectionStatus);
}

class Unauthorized extends ConclusionState {
  const Unauthorized({
    required ConclusionSelectionStatus conclusionSelectionStatus,
    required String msg,
  }) : super(conclusionSelectionStatus: conclusionSelectionStatus, msg: msg);
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
