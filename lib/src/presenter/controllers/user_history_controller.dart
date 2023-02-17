import 'package:get/get.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/domain/entities/user_history_entity.dart';
import 'package:tem_final/src/domain/entities/user_rating_entity.dart';
import 'package:tem_final/src/domain/usecases/get_local_user_history_usecase.dart';
import 'package:tem_final/src/presenter/controllers/tv_show_and_movie_controller.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';

import '../../core/resources/data_state.dart';

class UserHistoryController extends GetxController {
  UserHistoryController(this._getLocalUserHistoryUseCase);
  final GetLocalUserHistoryUseCase _getLocalUserHistoryUseCase;
  Rxn<UserHistory> userHistory = Rxn<UserHistory>();

  Rx<String> errorLoadUserHistory = "".obs;

  Future<void> getLocalUserHistory() async {
    print("geTlocal");
    //statusRating.value = StatusRating.loading;
    var resultGetLocalUserHistory = await _getLocalUserHistoryUseCase();

    if (resultGetLocalUserHistory is DataSucess) {
      print("carreguei");
      userHistory.value = resultGetLocalUserHistory.data;
      print("carreguei ${userHistory.value!.listUserRatings}");
      //statusRating.value = StatusRating.sucess;
    } else {
      print("n carreguei");
      errorLoadUserHistory.value = resultGetLocalUserHistory.error!.item1;
      //statusRating.value = StatusRating.error;
    }
  }
}
