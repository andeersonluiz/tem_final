import 'package:either_dart/either.dart';
import 'package:tem_final/src/core/resources/data_state.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tuple/tuple.dart';

abstract class UserRepository {
  Future<DataState<String>> submitReport(
    Tuple4<String, String, ReportType, String> params,
  );

  Future<DataState<String>> loginViaGoogle();
  Future<DataState<String>> logOut();

  Future<DataState<UserHistory?>> getLocalUserHistory();
  Future<Either<String, Tuple2<String, StackTrace>>> getUserId();
}