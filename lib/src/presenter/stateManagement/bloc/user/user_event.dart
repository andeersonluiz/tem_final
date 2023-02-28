import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginUserEvent extends UserEvent {}

class LogOutUserEvent extends UserEvent {}

//class RemoveUserEvent extends UserEvent {}

class LoadUserEvent extends UserEvent {}
