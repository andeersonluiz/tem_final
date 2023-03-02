import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/resources/device_info.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/datasource/auth/firebase_auth_handler_service.dart';
import 'package:tem_final/src/data/datasource/local/local_preferences_handler_service.dart';
import 'package:tem_final/src/data/datasource/remote/firebase_handler_service.dart';
import 'package:tem_final/src/domain/repositories/data_integrity_checker_repository.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

class DataIntegrityCheckerRepositoryImpl implements DataIntegrityChecker {
  DataIntegrityCheckerRepositoryImpl({
    required this.firebaseHandlerService,
    required this.firebaseAuthHandlerService,
    required this.localPreferencesHandlerService,
    required this.userRepository,
  });
  final FirebaseHandlerService firebaseHandlerService;
  final FirebaseAuthHandlerService firebaseAuthHandlerService;
  final LocalPreferencesHandlerService localPreferencesHandlerService;
  final UserRepository userRepository;

  @override
  Future<void> checkIntegrity() async {
    await localPreferencesHandlerService.checkFavoriteTvShowAndMovieIntegrity();
    await localPreferencesHandlerService
        .checkUserViewedTvShowAndMovieIntegrity();
    await localPreferencesHandlerService
        .checkUserViewedTvShowAndMovieIntegrity();
    var resultUserHistoryIntegrity =
        await localPreferencesHandlerService.checkUserHistoryIntegrity();
    if (!resultUserHistoryIntegrity) {
      await userRepository.logOut();
    }
  }

  @override
  Future<DataState<bool>> checkMultiDeviceLoginStatus() async {
    var idFromFirestore =
        await firebaseAuthHandlerService.getUserIdFromAuthFirestore();

    var localId = await localPreferencesHandlerService.loadUserId();

    if (idFromFirestore.isLeft && localId.isLeft) {
      if (idFromFirestore != localId) {
        await userRepository.logOut();
      }
      return const DataSucess(true);
    }
    String stackTraceidFromFirestore = idFromFirestore.isRight
        ? idFromFirestore.right.item2.toString()
        : "no has error";
    String stackTraceLocalId =
        localId.isRight ? localId.right.item2.toString() : "no has error";

    return DataFailed(
      Tuple2(
          Strings.multiDeviceError,
          StackTrace.fromString(
              "idFromFirestore: $stackTraceidFromFirestore | localId: $stackTraceLocalId")),
    );
  }

  @override
  Future<bool> checkUserIsLoggedOtherDevice() async {
    String deviceId = await DeviceInfo.getId();
    var userHistory = localPreferencesHandlerService.getUserHistory();
    if (userHistory.isLeft) {
      var resultAuth = await firebaseHandlerService.checkDeviceIdFromUser(
          userHistory.left!, deviceId);
      if (resultAuth.isLeft && !resultAuth.left) {
        return true;
      }
    }
    return false;
  }
}
