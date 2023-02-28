import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/domain/usecases/log_out_usecase.dart';
import 'package:tem_final/src/domain/usecases/login_via_google_usecase.dart';
import 'package:tem_final/src/domain/usecases/remove_user_usecase.dart';
import 'package:tem_final/src/domain/usecases/verifiy_user_is_logged_usecase.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_state.dart';

import '../../../../domain/usecases/get_username_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._loginViaGoogleUseCase, this._logOutUseCase,
      this._verifiyUserIsLoggedUseCase, this._getUsernameUseCase)
      : super(UserLoading(username: '')) {
    on<LoginUserEvent>(_login);
    on<LogOutUserEvent>(_logOut);
    on<LoadUserEvent>(_verifyUserIsLogged);
  }

  final LoginViaGoogleUseCase _loginViaGoogleUseCase;
  final LogOutUseCase _logOutUseCase;
  //final RemoveUserUseCase _removeUserUseCase;
  final VerifiyUserIsLoggedUseCase _verifiyUserIsLoggedUseCase;
  final GetUsernameUseCase _getUsernameUseCase;

  Future<void> _login(LoginUserEvent event, Emitter<UserState> emit) async {
    var resultLogin = await _loginViaGoogleUseCase();
    var resultUserName = await _getUsernameUseCase();
    if (resultLogin is DataSucess) {
      emit(UserLoggedDone(
          msg: state.msg != resultLogin.data! ? resultLogin.data! : "",
          username: resultUserName));
    } else {
      emit(UserError(
          msg: state.msg != resultLogin.error!.item1
              ? resultLogin.error!.item1
              : "",
          username: ""));
    }
  }

  Future<void> _logOut(LogOutUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading(username: state.username));

    var resultLogOut = await _logOutUseCase();
    if (resultLogOut is DataSucess) {
      emit(UserNotLoggedDone(
          msg: state.msg != resultLogOut.data! ? resultLogOut.data! : "",
          username: ""));
    } else {
      emit(UserError(
          msg: state.msg != resultLogOut.error!.item1
              ? resultLogOut.error!.item1
              : "",
          username: ""));
    }
  }
/*
  Future<void> _removeUser(
      RemoveUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    var resultRemoveUser = await _removeUserUseCase();
    if (resultRemoveUser is DataSucess) {
      emit(UserNotLoggedDone(
          msg: state.msg != resultRemoveUser.data!
              ? resultRemoveUser.data!
              : ""));
    } else {
      emit(UserError(
          msg: state.msg != resultRemoveUser.error!.item1
              ? resultRemoveUser.error!.item1
              : ""));
    }
  }*/

  Future<void> _verifyUserIsLogged(
      LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading(username: state.username));

    var resultIsLogged = await _verifiyUserIsLoggedUseCase();
    if (resultIsLogged) {
      var resultUserName = await _getUsernameUseCase();

      emit(UserLogged(msg: "", username: resultUserName));
    } else {
      emit(const UserNotLogged(msg: "", username: ""));
    }
  }
}
