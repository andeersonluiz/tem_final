// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String? msg;
  final String username;
  const UserState({this.msg, required this.username});
  @override
  List<Object> get props => [msg ?? ""];
}

class UserLoading extends UserState {
  UserLoading({required super.username});
}

class UserLogged extends UserState {
  const UserLogged({required super.msg, required super.username});
}

class UserLoggedDone extends UserState {
  const UserLoggedDone({required super.msg, required super.username});
}

class UserNotLogged extends UserState {
  const UserNotLogged({required super.msg, required super.username});
}

class UserNotLoggedDone extends UserState {
  const UserNotLoggedDone({required super.msg, required super.username});
}

class UserError extends UserState {
  const UserError({required super.msg, required super.username});
}
