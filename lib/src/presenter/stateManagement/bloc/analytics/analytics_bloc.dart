import 'package:bloc/bloc.dart';
import 'package:tem_final/src/domain/usecases/submit_report_usecase.dart';
import 'package:tem_final/src/domain/usecases/update_view_count_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_event.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, int> {
  AnalyticsBloc(
      this._updateTvShowAndMovieViewCountUseCase, this._submitReportUseCase)
      : super(0) {
    on<UpdateViewCountEvent>(_updateViewCount);
    on<SendFeedbackEvent>(_sendReport);
  }
  final UpdateTvShowAndMovieViewCountUseCase
      _updateTvShowAndMovieViewCountUseCase;
  final SubmitReportUseCase _submitReportUseCase;
  Future<void> _updateViewCount(
      UpdateViewCountEvent event, Emitter<int> emit) async {
    await _updateTvShowAndMovieViewCountUseCase(event.idTvShowAndMovie!);
  }

  Future<void> _sendReport(SendFeedbackEvent event, Emitter<int> emit) async {
    await _submitReportUseCase(event.feedbackParams!);
  }
}
