import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/data/datasource/auth/firebase_auth_handler_service.dart';
import 'package:tem_final/src/data/datasource/local/local_preferences_handler_service.dart';
import 'package:tem_final/src/data/datasource/remote/firebase_handler_service.dart';
import 'package:tem_final/src/data/mappers/user_history_mapper.dart';
import 'package:tem_final/src/data/models/user_history_model.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/repositories/user_repository.dart';
import 'package:tuple/tuple.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(
      {required this.firebaseHandlerService,
      required this.firebaseAuthHandlerService,
      required this.localPreferencesHandlerService,
      required this.userHistoryMapper});
  final FirebaseHandlerService firebaseHandlerService;
  final FirebaseAuthHandlerService firebaseAuthHandlerService;
  final LocalPreferencesHandlerService localPreferencesHandlerService;
  final UserHistoryMapper userHistoryMapper;
  @override
  Future<DataState<String>> logOut() async {
    var logOutResult = await firebaseAuthHandlerService.logOut();
    if (logOutResult.isLeft) {
      await localPreferencesHandlerService.clearUserHistory();
      await localPreferencesHandlerService.clearUserId();
      await localPreferencesHandlerService.clearUsername();

      return DataSucess(logOutResult.left);
    } else {
      return DataFailed(logOutResult.right, isLog: false);
    }
  }

  @override
  Future<DataState<String>> loginViaGoogle() async {
    var loginResult = await firebaseAuthHandlerService.loginViaGoogle();
    if (loginResult.isLeft) {
      Either<bool, Tuple2<String, StackTrace>> resulSetUserId =
          await localPreferencesHandlerService
              .setUserId(loginResult.left.item1);
      await localPreferencesHandlerService.setUsername(loginResult.left.item2);
      DataState<bool> resultLoadUserHistory =
          await _loadUserHistory(loginResult.left.item1);
      if (resulSetUserId.isLeft && resultLoadUserHistory is DataSucess) {
        return const DataSucess(Strings.loginSucess);
      } else {
        String stackTraceSetUserId = resulSetUserId.isRight
            ? resulSetUserId.right.item2.toString()
            : "no has error";
        String stackTraceLoadUserHistory = resultLoadUserHistory is DataFailed
            ? resultLoadUserHistory.error!.toString()
            : "no has error";

        return DataFailed(
            Tuple2(
                Strings.loginError,
                StackTrace.fromString(
                    "setUserId: $stackTraceSetUserId | loadUserHistory: $stackTraceLoadUserHistory")),
            isLog: false);
      }
    } else {
      return DataFailed(loginResult.right, isLog: false);
    }
  }

/*
  @override
  Future<DataState<String>> removeUser() async {
    var userIdResult = await localPreferencesHandlerService.loadUserId();
    StackTrace stacktrace = StackTrace.empty;
    if (userIdResult.isLeft) {
      var resultRemoveUser =
          await firebaseHandlerService.removeUser(userIdResult.left);
      if (resultRemoveUser.isLeft) {
        await logOut();
        return DataSucess(resultRemoveUser.left);
      } else {
        stacktrace = resultRemoveUser.right.item2;
      }
    } else {
      stacktrace = userIdResult.right.item2;
    }
    print("n foi $stacktrace");
    return DataFailed(Tuple2(Strings.errorRemoveUser, stacktrace),
        isLog: false);
  }*/

  @override
  Future<Either<String, Tuple2<String, StackTrace>>> getUserId() async {
    return await localPreferencesHandlerService.loadUserId();
  }

  @override
  Future<String> getUsername() async {
    return await localPreferencesHandlerService.loadUsername();
  }

  @override
  Future<DataState<String>> submitReport(
    Tuple3<String, ReportType, String> params,
  ) async {
    Either<String, Tuple2<String, StackTrace>> submitResponse =
        await firebaseHandlerService.submitReport(
            params.item1, params.item2, params.item3);

    if (submitResponse.isLeft) {
      return DataSucess(submitResponse.left);
    }
    return DataFailed(submitResponse.right, isLog: false);
  }

  Future<DataState<bool>> _loadUserHistory(String userId) async {
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultUserHistory =
        await firebaseHandlerService.getUserHistory(userId);
    if (resultUserHistory.isLeft) {
      UserHistoryModel? userHistoryModel = resultUserHistory.left;
      if (userHistoryModel == null) {
        userHistoryModel = UserHistoryModel(
            idUser: userId, listUserChoices: [], listUserRatings: []);
        var resultSetUserHistory =
            await firebaseHandlerService.setUserHistory(userHistoryModel);
        if (resultSetUserHistory.isRight) {
          return DataFailed(resultSetUserHistory.right, isLog: false);
        }
      }

      Either<bool, Tuple2<String, StackTrace>> resultUpdateUserHistory =
          await localPreferencesHandlerService
              .updateUserHistory(userHistoryModel);
      if (resultUpdateUserHistory.isLeft) {
        return DataSucess(resultUpdateUserHistory.left);
      } else {
        return DataFailed(resultUpdateUserHistory.right, isLog: false);
      }
    } else {
      return DataFailed(resultUserHistory.right, isLog: false);
    }
  }

  @override
  Future<DataState<UserHistory?>> getLocalUserHistory() async {
    Either<UserHistoryModel?, Tuple2<String, StackTrace>> resultGetUserHistory =
        localPreferencesHandlerService.getUserHistory();

    if (resultGetUserHistory.isLeft) {
      if (resultGetUserHistory.left == null) return const DataSucess(null);

      return DataSucess(
          userHistoryMapper.modelToEntity(resultGetUserHistory.left!));
    } else {
      return DataFailed(resultGetUserHistory.right, isLog: false);
    }
  }

  @override
  Future<bool> verifyUserIsLogged() async {
    var resultLoadUserId = await localPreferencesHandlerService.loadUserId();
    if (resultLoadUserId.isLeft && resultLoadUserId.left.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
