import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/strings.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_event.dart';
import 'package:tuple/tuple.dart';

class CustomFeedback extends StatefulWidget {
  const CustomFeedback(
      {super.key, required this.reportType, this.titleTvShowAndMovie = ""});
  final String titleTvShowAndMovie;
  final ReportType reportType;

  @override
  State<CustomFeedback> createState() => _CustomFeedbackState();
}

class _CustomFeedbackState extends State<CustomFeedback> {
  final TextEditingController textEditingController = TextEditingController();
  late AnalyticsBloc analyticsBloc;
  @override
  void initState() {
    analyticsBloc = context.read<AnalyticsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late final String title;

    late final String hint;
    late final String msgSucess;
    if (widget.reportType == ReportType.feedback) {
      title = "Feedback";
      hint = "Digite seu feedback";
      msgSucess = Strings.sendFeedbackSucess;
    } else if (widget.reportType == ReportType.problem) {
      String complement = widget.titleTvShowAndMovie.isNotEmpty
          ? " com: ${widget.titleTvShowAndMovie}"
          : "";
      title = "Relatar Problema$complement";
      hint = "Nos conte o que ocorreu";
      msgSucess = Strings.sendProblemSucess;
    }
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                    fontFamily: fontFamily,
                    color: textColorFilledOption,
                    fontWeight: FontWeight.bold,
                    fontSize: 22)),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
            child: Container(
              color: Colors.transparent,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(color: ratingColorPosterMainPage),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(width: 0)),
                    counterStyle: const TextStyle(
                        fontFamily: fontFamily, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    hintText: hint,
                    hintStyle: const TextStyle(
                        color: foregroundColor, fontFamily: fontFamily)),
                cursorColor: Colors.white,
                maxLength: 1000,
                maxLines: 5,
                style: const TextStyle(
                    fontFamily: fontFamily, color: foregroundColor),
              ),
            ),
          ),
          Container(
              width: 100.w,
              height: 75,
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 24.0),
              child: CustomButton(
                  onPressed: () {
                    if (textEditingController.text.isEmpty) {
                      CustomToast(msg: Strings.errorEmptyFeedback);

                      return;
                    }
                    analyticsBloc.add(SendFeedbackEvent(
                        feedbackParams: Tuple3(textEditingController.text,
                            widget.reportType, "")));
                    CustomToast(msg: msgSucess);
                    Navigator.pop(context);
                  },
                  text: "Enviar"))
        ],
      ),
    );
  }
}
