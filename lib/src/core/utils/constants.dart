enum ConclusionType { conclusive, openEnded, unknown }

enum ReportType { problem, feedback, changeData }

enum PaginationType {
  searchPage,
  genrePage,
}

enum PaginationTypeMainPage { all, tvShow, movie }

enum Filter { all, movie, tvShow }

enum GenreType {
  release,
  actionAdventure,
  animation,
  comedy,
  crime,
  documentary,
  drama,
  fantasy,
  history,
  horror,
  family,
  musicMusical,
  mysteryThriller,
  romance,
  scienceFiction,
  sportFitness,
  warMilitary,
  western,
  realityTV,
  madeInEurope
}

enum StatusLoadingTvShowAndMovie { firstRun, loading, error, sucess }

enum StatusLoadingOnlyTvShowAndMovie { firstRun, loading, error, sucess }

enum StatusRating { firstRun, loading, error, sucess }

extension ReportTypeString on ReportType {
  String get string {
    switch (this) {
      case ReportType.problem:
        return "Solicitação";
      case ReportType.feedback:
        return "Feedback";
      case ReportType.changeData:
        return "Atualização";
      default:
        return "";
    }
  }
}

extension GenreTypeDisplay on GenreType {
  String get string {
    switch (this) {
      case GenreType.actionAdventure:
        return "Ação & Aventura";
      case GenreType.animation:
        return "Animação";
      case GenreType.comedy:
        return "Comédia";
      case GenreType.crime:
        return "Crime";
      case GenreType.documentary:
        return "Documentário";
      case GenreType.drama:
        return "Drama";
      case GenreType.fantasy:
        return "Fantasia";
      case GenreType.history:
        return "História";
      case GenreType.horror:
        return "Terror";
      case GenreType.family:
        return "Família";
      case GenreType.musicMusical:
        return "Música & Musical";
      case GenreType.mysteryThriller:
        return "Mistério & Thriller";
      case GenreType.romance:
        return "Romance";
      case GenreType.scienceFiction:
        return "Ficção Científica";
      case GenreType.sportFitness:
        return "Esporte & Fitness";
      case GenreType.warMilitary:
        return "Guerra & Militar";
      case GenreType.western:
        return "Western";
      case GenreType.realityTV:
        return "Reality TV";
      case GenreType.madeInEurope:
        return "Made in Europe";
      default:
        return "";
    }
  }
}

extension FilterString on Filter {
  String get string {
    switch (this) {
      case Filter.all:
        return "Tudo";
      case Filter.movie:
        return "Filmes";
      case Filter.tvShow:
        return "Séries";
      default:
        return "";
    }
  }
}

final List<GenreType> kGenresList =
    GenreType.values.where((element) => element.string.isNotEmpty).toList();
const int pageSize = 15;

const int pageSizeMainPage = 5;

const String kFavoritesTvShowAndMoviesKeyEncrypted =
    "kFavoritesTvShowAndMoviesKeyEncrypted";

const String kUserIdKeyEncrypted = "kUserIdKeyEncrypted";

const String kViwedTvShowAndMoviesUserIdKeyEncrypted =
    "kViwedTvShowAndMoviesUserIdKeyEncrypted";

const String kUserHistoryKeyEncrypted = "kUserHistoryKeyEncrypted";
const String kUserGenreEncypted = "kUserGenreEncypted";

const String kDocumentTvShowAndMovies = "tvShowAndMovies";
const String kDocumentUserHistory = "usersHistory";
const int kMaxTvShowAndMoviesByGenre = 10;

const String kViewAll = "Ver tudo";
