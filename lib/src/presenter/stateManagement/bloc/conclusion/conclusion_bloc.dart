import 'package:bloc/bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/usecases/select_conclusion_usecase.dart';
import 'package:tem_final/src/domain/usecases/verifiy_user_is_logged_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/conclusion/conclusion_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/conclusion/conclusion_state.dart';
import 'package:tuple/tuple.dart';

class ConclusionBloc extends Bloc<ConclusionEvent, ConclusionState> {
  ConclusionBloc(
      this._selectConclusionUseCase, this._verifitUserIsLoggedUseCase)
      : super(const NoSelectConclusion(
          conclusionSelectionStatus: ConclusionSelectionStatus(
            hasSelectedFirstConclusion: true,
            hasSelectedSecondConclusion: false,
            bothConclusionSelected: false,
            showAnimationOpacitySecondConclusion: false,
            showButton: false,
          ),
        )) {
    on<SelectFirstConclusionEvent>(_selectFirstConclusion);
    on<BackConclusionEvent>(_backConclusion);
    on<ShowAnimation>(_showAnimation);
    on<SelectSecondConclusionEvent>(_selectSecondConclusion);
    on<SendConclusionEvent>(_sendConclusion);
    on<ResetConclusionEvent>(_resetConclusion);
    on<ShowResultsEvent>(_showResults);
  }

  final SelectConclusionUseCase _selectConclusionUseCase;
  final VerifiyUserIsLoggedUseCase _verifitUserIsLoggedUseCase;

  Future<void> _selectFirstConclusion(
      SelectFirstConclusionEvent event, Emitter<ConclusionState> emit) async {
    var resultVerifyIsLogged = await _verifitUserIsLoggedUseCase();
    if (!resultVerifyIsLogged) {
      emit(Unauthorized(
          conclusionSelectionStatus: state.conclusionSelectionStatus,
          msg: Strings.unauthorizedUser));
    } else {
      final newConclusionSelectionStatus =
          state.conclusionSelectionStatus.copyWith(
        hasSelectedFirstConclusion: false,
        hasSelectedSecondConclusion: true,
        bothConclusionSelected: false,
        showAnimationOpacitySecondConclusion: false,
      );
      emit(SelectFirstConclusion(
          conclusion: event.conclusion!,
          showAnimation: false,
          conclusionSelectionStatus: newConclusionSelectionStatus));
    }
  }

  Future<void> _backConclusion(
      BackConclusionEvent event, Emitter<ConclusionState> emit) async {
    final newConclusionSelectionStatus =
        state.conclusionSelectionStatus.copyWith(
      hasSelectedFirstConclusion: true,
      hasSelectedSecondConclusion: false,
      bothConclusionSelected: false,
      showAnimationOpacitySecondConclusion: false,
      showButton: false,
    );
    emit(SelectFirstConclusion(
        conclusion: event.conclusion!,
        showAnimation: false,
        conclusionSelectionStatus: newConclusionSelectionStatus));
  }

  Future<void> _showAnimation(
      ShowAnimation event, Emitter<ConclusionState> emit) async {
    if (state is Unauthorized || state is NoSelectConclusion) return;
    final newConclusionSelectionStatus =
        state.conclusionSelectionStatus.copyWith(
      hasSelectedFirstConclusion: false,
      hasSelectedSecondConclusion: true,
      bothConclusionSelected: false,
      showAnimationOpacitySecondConclusion: true,
      showButton: true,
    );
    emit(SelectFirstConclusion(
        conclusion: event.conclusion,
        showAnimation: true,
        conclusionSelectionStatus: newConclusionSelectionStatus));
  }

  Future<void> _selectSecondConclusion(
      SelectSecondConclusionEvent event, Emitter<ConclusionState> emit) async {
    final newConclusionSelectionStatus =
        state.conclusionSelectionStatus.copyWith(
      hasSelectedFirstConclusion: false,
      hasSelectedSecondConclusion: true,
      bothConclusionSelected: true,
      showAnimationOpacitySecondConclusion: true,
      showButton: true,
    );
    emit(SelectSecondConclusion(
        conclusion: event.conclusion!,
        conclusionHasFinal: event.conclusionHasFinal,
        conclusionNoHasFinal: event.conclusionNoHasFinal,
        conclusionSelectionStatus: newConclusionSelectionStatus));
  }

  Future<void> _sendConclusion(
      SendConclusionEvent event, Emitter<ConclusionState> emit) async {
    ConclusionType conclusionType;
    if (state.conclusionHasFinal != null) {
      if (state.conclusion == Conclusion.hasFinal &&
          state.conclusionHasFinal == ConclusionHasFinal.closed) {
        conclusionType = ConclusionType.hasFinalAndClosed;
      } else {
        conclusionType = ConclusionType.hasFinalAndOpened;
      }
    } else {
      if (state.conclusion == Conclusion.noHasFinal &&
          state.conclusionNoHasFinal == ConclusionNoHasFinal.newSeason) {
        conclusionType = ConclusionType.noHasfinalAndNewSeason;
      } else {
        conclusionType = ConclusionType.noHasfinalAndNoNewSeason;
      }
    }
    var resultSelectConclusion = await _selectConclusionUseCase(
        Tuple2(event.tvShowAndMovie!, conclusionType));
    String msg = "";
    if (resultSelectConclusion is DataSucess) {
      msg = resultSelectConclusion.data!;
      emit(SelectConclusionDone(
          conclusionSelectionStatus: state.conclusionSelectionStatus,
          msg: msg));
    } else {
      msg = resultSelectConclusion.error!.item1;
      emit(SelectConclusionError(
          conclusionSelectionStatus: state.conclusionSelectionStatus,
          msg: msg));
    }
  }

  Future<void> _showResults(
      ShowResultsEvent event, Emitter<ConclusionState> emit) async {
    emit(ConclusionResults(
        conclusionSelectionStatus: state.conclusionSelectionStatus,
        tvShowAndMovieInfoStatus:
            event.tvShowAndMovie!.listTvShowAndMovieInfoStatusBySeason.last));
  }

  Future<void> _resetConclusion(
      ResetConclusionEvent event, Emitter<ConclusionState> emit) async {
    final newConclusionSelectionStatus =
        state.conclusionSelectionStatus.copyWith(
      hasSelectedFirstConclusion: true,
      hasSelectedSecondConclusion: false,
      bothConclusionSelected: false,
      showAnimationOpacitySecondConclusion: false,
      showButton: false,
    );
    emit(NoSelectConclusion(
        conclusionSelectionStatus: newConclusionSelectionStatus));
  }
}
