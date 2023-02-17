import 'package:tem_final/src/core/resources/custom_icons.dart';

generateIconAgeClassification(String ageClassification) {
  switch (ageClassification) {
    case "L":
      return CustomIcons.L;
    case "10":
      return CustomIcons.teen;
    case "12":
      return CustomIcons.twelve;
    case "14":
      return CustomIcons.fourteen;
    case "16":
      return CustomIcons.sixteen;
    case "18":
      return CustomIcons.eighteen;
  }
}
