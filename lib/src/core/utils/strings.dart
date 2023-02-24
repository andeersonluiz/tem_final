import 'package:intl/intl.dart';

class Strings {
  static const String msgErrorGetLocalPreferences =
      "Não foi possível recuperar as preferências locais. Por favor, tente novamente mais tarde.";
  static const String msgErrorSetLocalPreferences =
      "Ocorreu um erro ao salvar as preferências locais. Verifique sua conexão com a internet e tente novamente.";
  static const String msgUserNotFoundPreferences =
      "Não há nenhum usuário logado no momento.";
  static const String msgErrorConnectionFirebase =
      "Não foi possível conectar ao banco de dados. Verifique sua conexão com a internet e tente novamente.";
  static const String multiDeviceError =
      "Mais de um dispositivo conectado e/ou violação da integridade de login";

  static const aborted =
      "Operação foi abortada devido a um problema de concorrência, como aborto de transação, etc.";
  static const alreadyExists = "Algum documento que tentamos criar já existe.";
  static const cancelled =
      "A operação foi cancelada (normalmente pelo chamador).";
  static const dataLoss = "Perda de dados ou corrupção irreparável.";
  static const deadlineExceeded =
      "Prazo expirado antes que a operação pudesse ser concluída.";
  static const failedPrecondition =
      "A operação foi rejeitada porque o sistema não está em um estado necessário para a execução da operação.";
  static const internal = "Erros internos.";
  static const invalidArgument = "O cliente especificou um argumento inválido.";
  static const notFound = "Algum documento solicitado não foi encontrado.";
  static const ok = "A operação foi concluída com sucesso.";
  static const outOfRange = "A operação foi tentada além do intervalo válido.";
  static const permissionDenied =
      "O chamador não tem permissão para executar a operação especificada.";
  static const resourceExhausted =
      "Algum recurso foi esgotado, talvez uma quota por usuário ou talvez todo o sistema de arquivos esteja sem espaço.";
  static const unauthenticated =
      "A solicitação não possui credenciais de autenticação válidas para a operação.";
  static const unavailable = "O serviço está atualmente indisponível.";
  static const unimplemented =
      "Operação não é implementada ou não é suportada/habilitada.";
  static const unknown =
      "Erro desconhecido ou de um domínio de erro diferente.";

  static const accountExistsWithDifferentCredential =
      'Já existe uma conta com este endereço de e-mail. Por favor, faça login com outra conta.';
  static const invalidCredential = 'Credencial inválida ou expirada.';
  static const operationNotAllowed =
      'Este tipo de conta não está habilitado. Por favor, habilite o tipo de conta no console.';
  static const userDisabled =
      'Usuário correspondente à credencial desabilitado.';
  static const userNotFound =
      'Não há usuário correspondente ao endereço de e-mail fornecido.';
  static const wrongPassword =
      'Senha inválida para o endereço de e-mail fornecido ou a conta correspondente não tem uma senha.';
  static const invalidVerificationCode =
      'Código de verificação inválido na credencial do provedor PhoneAuthProvider.';
  static const invalidVerificationId =
      'ID de verificação inválido na credencial do provedor PhoneAuthProvider.';

  static const defaultError = "Erro inesperado, tente novamente mais tarde.";
  static const defaultErrorFirebase =
      "Erro inesperado, tente novamente mais tarde. Código do erro: ";

  static const errorPlatform =
      "Ocorreu um erro ao obter a versão da plataforma.";

  static const noConnection =
      "Você está offline, verifique sua conexão com a internet e tente novamente.";
  static const msgSucessSelectConclusion = "Conclusão selecionado com sucesso!";
  static const msgSerieAndMovieNotFoundSelectConclusion =
      "Id Serie/Filme não encontrado na seleção de conlusão, tente novamente mais tarde";
  static const msgSerieAndMovieNotFoundIncrementTvShowAndMovieViewCount =
      "Id Serie/Filme não encontrado na atualização de visualização, tente novamente mais tarde";

  static const msgSucessAddFavorite = " favoritado com sucesso";

  static const msgSufixReportProblem = " enviada com sucesso.";
  static const msgSufixReportFeedback = " enviado com sucesso, obrigado!!";
  static const msgSufixReportChangedData = " enviada com sucesso.";

  static const msgNotFoundIdMovieAndSerie =
      "Série ou filme não encontrado, tente novamente mais tarde";

  static const msgDataInconsistency = "Inconsistência nos dados locais";

  static const loginSucess = "Logado com sucesso!!";
  static const loginError = "Erro ao fazer login, tente novamente mais tarde.";
  static const logOutSucess = "Saiu com sucesso";
  static const logOutFailed =
      "Houve um erro ao sair, tente novamente mais tarde.";
  static const userNotFoundFirebase =
      'Usuário não encontrado, faça o login novamente.';
  static const tvShowAndNotFound = "Filme/Série não encontrado";

  static const ratingSuccessful = "Avaliação enviada com sucesso. Obrigado!!";
  static const errorToUpdateRating =
      "Erro ao atualizar avaliação, tente novamente mais tarde";
  static const unauthorizedUser = "Usuário não autorizado, faça o login.";

  static const msgNotFoundSearch = "Não há resultados para sua busca :(";

  //*Widgets names*//
  static const yourRatingText = "Sua avaliação";
  static const myRatingText = "Minha avaliação: ";
  static const updateRatingText = "Atualizar avaliação";
  static const sendRatingText = "Atualizar avaliação";
  static const genresText = "Gêneros";
  static const synopsisText = "Sinopse";
  static const seasonsText = "Temporadas";
  static const seasonSingularText = "Temporada ";
  static const classificationText = "Classificação";
  static const hasEndText = "Tem final?";
  static const infosText = "Informações";
  static const backText = "Voltar";
  static const confirmText = "Confirmar";
  static const resultText = "Resultados";
  static const viewResultsText = "Ver resultados";
  static const hasFinalOpenedText = "TEM FINAL, E SEU FINAL É ABERTO";
  static const hasFinalClosedText = "TEM FINAL, E SEU FINAL É FECHADO";
  static const noHasFinalNewSeasonText =
      "NÃO TEM FINAL, MAS HAVÉRA NOVA TEMPORADA";
  static const noHasFinalNoNewSeasonText =
      "NÃO TEM FINAL E NÃO HAVÉRA NOVA TEMPORADA";

  static const hasFinalOptionText = "TEM FINAL";
  static const noHasFinalOptionText = "NÃO TEM FINAL";

  static const hasFinalConjuctionText = ", E SEU FINAL ESTÁ...";
  static const noHasFinalConjuctionText = ", MAS...";

  static const openedOptionText = "ABERTO";
  static const closedOptionText = "FECHADO";
  static const newSeasonOptionText = "HAVERÁ NOVA TEMPORADA";
  static const noNewSeasonOptionText = "NÃO HAVERÁ NOVA TEMPORADA";

  static const noEnoughData = "Sem avaliações suficientes";

  static const headerSearchRecentText = "Visto recentemente";
  static const headerSearchResultsText = "Resultados";

  static generateButtonText({required bool isMovie}) {
    return "Avalie ${isMovie ? "o filme" : "a série"}";
  }

  static generateTypeTvShowAndMovie({required bool isMovie}) {
    return isMovie ? "O filme" : "A série";
  }

  static generateDateLastUpdate({required DateTime lastUpdate}) {
    return "(Atualizado em: ${DateFormat("dd/MM/yyyy").format(lastUpdate)})";
  }

  static generateHaderSearchResultsText({required String query}) {
    return "Resultados para busca \"$query\"";
  }
}
