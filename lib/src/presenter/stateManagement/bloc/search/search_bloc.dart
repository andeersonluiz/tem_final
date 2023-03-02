import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/entities/tv_show_and_movie_entity.dart';
import 'package:tem_final/src/domain/usecases/get_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/domain/usecases/set_recents_tv_show_and_movie_viewed.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/search/search_state.dart';

import '../../../../core/utils/strings.dart';
import '../../../../domain/usecases/search_tv_show_and_movie_usecase.dart';

EventTransformer<Event> debounce<Event>({
  Duration duration = const Duration(milliseconds: 500),
}) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
      this._searchTvShowAndMovieUseCase,
      this._setRecentsTvShowAndMovieViewedUseCase,
      this._getRecentsTvShowAndMovieViewedUseCase)
      : super(const SearchEmpty(queryResultList: [], notFoundList: "")) {
    on<SearchQueryEvent>(_searchQuery, transformer: debounce());
    on<GetRecentsEvent>(_getRecents);
    on<ShowFakeLoadingEvent>(_showFakeLoding);
    on<SetRecentsEvent>(_addRecents);
  }

  final SearchTvShowAndMovieUseCase _searchTvShowAndMovieUseCase;
  final SetRecentsTvShowAndMovieViewedUseCase
      _setRecentsTvShowAndMovieViewedUseCase;
  final GetRecentsTvShowAndMovieViewedUseCase
      _getRecentsTvShowAndMovieViewedUseCase;
  String lastQuery = "";
  Future<void> _searchQuery(
      SearchQueryEvent event, Emitter<SearchState> emit) async {
    if ((event.query == lastQuery ||
            state.header == Strings.headerSearchRecentText) &&
        !event.refresh) return;
    lastQuery = event.query;
    DataState<List<TvShowAndMovie>> results =
        await _searchTvShowAndMovieUseCase(event.query);
    if (results is DataSucess) {
      if (results.data!.isEmpty) {
        emit(SearchEmpty(
            queryResultList: results.data!,
            notFoundList: Strings.msgNotFoundSearch));
      } else {
        emit(SearchDone(
            queryResultList: results.data!,
            notFoundList: "",
            header:
                Strings.generateHaderSearchResultsText(query: event.query)));
      }
    } else {
      emit(SearchError(
          queryResultList: const [],
          notFoundList: "",
          errorMsg: results.error!.item1));
    }
  }

  Future<void> _getRecents(
      GetRecentsEvent event, Emitter<SearchState> emit) async {
    if (event.query.isNotEmpty) {
      emit(SearchLoading(
          queryResultList: state.queryResultList,
          notFoundList: state.notFoundList));
      await Future.delayed(const Duration(milliseconds: 500));
    }
    var resultGetRecents = await _getRecentsTvShowAndMovieViewedUseCase();
    lastQuery = event.query;
    if (resultGetRecents is DataSucess) {
      emit(SearchDone(
          queryResultList: resultGetRecents.data!.reversed.toList(),
          notFoundList: state.notFoundList,
          header: Strings.headerSearchRecentText));
    } else {
      emit(SearchError(
          queryResultList: resultGetRecents.data!,
          notFoundList: "",
          errorMsg: resultGetRecents.error!.item1));
    }
  }

  Future<void> _addRecents(
      SetRecentsEvent event, Emitter<SearchState> emit) async {
    await _setRecentsTvShowAndMovieViewedUseCase(event.tvShowAndMovie!);
  }

  Future<void> _showFakeLoding(
      ShowFakeLoadingEvent event, Emitter<SearchState> emit) async {
    if (event.query == lastQuery) return;
    emit(SearchLoading(
        queryResultList: state.queryResultList,
        notFoundList: state.notFoundList));
  }
}
