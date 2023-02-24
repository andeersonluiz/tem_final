import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tem_final/src/core/resources/connection_verifyer.dart';
import 'package:tem_final/src/core/resources/no_connection_exception.dart';
import 'package:tem_final/src/core/utils/strings.dart';

import 'package:tuple/tuple.dart';

class FirebaseAuthHandlerService {
  FirebaseAuthHandlerService() {
    _instance = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn();
  }
  late FirebaseAuth _instance;
  late GoogleSignIn _googleSignIn;
  Future<Either<String, Tuple2<String, StackTrace>>> loginViaGoogle() async {
    try {
      await ConnectionVerifyer.verify();

      final signInAccount = await _googleSignIn.signIn();
      final signInAuthentication = await signInAccount!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: signInAuthentication.accessToken,
        idToken: signInAuthentication.idToken,
      );
      await _instance.signInWithCredential(credential);
      String userId = _instance.currentUser!.uid;
      return Left(userId);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } on FirebaseAuthException catch (e, stacktrace) {
      return Right(
          Tuple2(_getErrorFromFirebaseAuthExceptionByCode(e.code), stacktrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(Strings.msgErrorConnectionFirebase,
          StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<String, Tuple2<String, StackTrace>>>
      getUserIdFromAuthFirestore() async {
    try {
      await ConnectionVerifyer.verify();
      User? user = _instance.currentUser;
      String uidUser = "";
      if (user != null) {
        uidUser = user.uid;
      }
      return Left(uidUser);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(
          Strings.logOutFailed, StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  Future<Either<String, Tuple2<String, StackTrace>>> logOut() async {
    try {
      await ConnectionVerifyer.verify();
      await _instance.signOut();
      await _googleSignIn.signOut();

      return const Left(Strings.logOutSucess);
    } on NoConnectionException catch (e) {
      return Right(Tuple2(e.message, e.stackTrace));
    } catch (e, stacktrace) {
      return Right(Tuple2(
          Strings.logOutFailed, StackTrace.fromString("$e\n$stacktrace")));
    }
  }

  String _getErrorFromFirebaseAuthExceptionByCode(String code) {
    switch (code.toUpperCase()) {
      case 'ACCOUNT-EXISTS-WITH-DIFFERENT-CREDENTIAL':
        return Strings.accountExistsWithDifferentCredential;
      case 'INVALID-CREDENTIAL':
        return Strings.invalidCredential;
      case 'OPERATION-NOT-ALLOWED':
        return Strings.operationNotAllowed;
      case 'USER-DISABLED':
        return Strings.userDisabled;
      case 'USER-NOT-FOUND':
        return Strings.userNotFound;
      case 'WRONG-PASSWORD':
        return Strings.wrongPassword;
      case 'INVALID-VERIFICATION-CODE':
        return Strings.invalidVerificationCode;
      case 'INVALID-VERIFICATION-ID':
        return Strings.invalidVerificationId;
      default:
        return Strings.defaultErrorFirebase + code;
    }
  }
}
