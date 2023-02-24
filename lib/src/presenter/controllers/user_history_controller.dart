import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';

import '../../core/resources/data_state.dart';

class UserHistoryController extends GetxController {
  UserHistoryController(this._getLocalUserHistoryUseCase);
  final GetLocalUserHistoryUseCase _getLocalUserHistoryUseCase;
  Rxn<UserHistory> userHistory = Rxn<UserHistory>();

  Rx<String> errorLoadUserHistory = "".obs;

  Future<void> getLocalUserHistory() async {
    debugPrint("geTlocal");
    //statusRating.value = StatusRating.loading;
    var resultGetLocalUserHistory = await _getLocalUserHistoryUseCase();

    if (resultGetLocalUserHistory is DataSucess) {
      debugPrint("carreguei");
      userHistory.value = resultGetLocalUserHistory.data;
      debugPrint("carreguei ${userHistory.value!.listUserRatings}");
      //statusRating.value = StatusRating.sucess;
    } else {
      debugPrint("n carreguei");
      errorLoadUserHistory.value = resultGetLocalUserHistory.error!.item1;
      //statusRating.value = StatusRating.error;
    }
  }
}
