import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/constants.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/routes_names.dart';
import 'package:tem_final/src/presenter/pages/login/login_dialog_page.dart';
import 'package:tem_final/src/presenter/pages/settings/widgets/content_item_widget.dart';
import 'package:tem_final/src/presenter/pages/settings/widgets/title_tile_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_bottom_navigation.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_feedback.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/analytics/analytics_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_state.dart';
import 'dart:math' as math;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late UserBloc userBloc;
  late AnalyticsBloc analyticsBloc;
  @override
  void initState() {
    userBloc = context.read<UserBloc>();
    analyticsBloc = context.read<AnalyticsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: const Text(
          "Configurações",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return state.username.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: foregroundColor),
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                "assets/user_no_logged.png",
                                width: 9.h,
                                height: 9.h,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Anônimo",
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.blueGrey.shade200,
                                    fontSize: 23)),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: foregroundColor),
                              padding: const EdgeInsets.all(16.0),
                              child: Transform.rotate(
                                angle: -math.pi / 20.0,
                                child: Image.asset(
                                  "assets/profile_image.png",
                                  color: ratingColorPosterMainPage,
                                  width: 5.h,
                                  height: 5.h,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(state.username,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.blueGrey.shade200,
                                    fontSize: 23)),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
          Expanded(
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TitleItem(title: "CONTA"),
                    BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                      if (state is UserNotLoggedDone ||
                          state is UserLoggedDone) {
                        CustomToast(msg: state.msg!);
                        userBloc.add(LoadUserEvent());
                      }
                      if (state is UserNotLogged) {
                        return ContentItem(
                          title: "Entrar",
                          leading: const Icon(
                            FontAwesomeIcons.arrowRightToBracket,
                            color: Colors.white,
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const LoginDialogPage());
                          },
                        );
                      } else if (state is UserLogged) {
                        return ContentItem(
                          title: "Sair",
                          leading: Transform.rotate(
                              angle: 180 * math.pi / 180,
                              child: const Icon(
                                FontAwesomeIcons.arrowRightFromBracket,
                                color: Colors.white,
                              )),
                          onTap: () {
                            userBloc.add(LogOutUserEvent());
                          },
                        );
                      }
                      if (state is UserError) {
                        CustomToast(msg: state.msg!);
                        return ContentItem(
                          title: "Entrar",
                          leading: const Icon(
                            FontAwesomeIcons.arrowRightToBracket,
                            color: Colors.white,
                          ),
                          onTap: () {},
                        );
                      } else {
                        return const CustomLoadingWidget();
                      }
                    }),
                    const TitleItem(title: "FEEDBACK"),
                    ContentItem(
                      title: "Dar feedback",
                      leading: const Icon(
                        FontAwesomeIcons.comments,
                        color: Colors.white,
                      ),
                      onTap: () {
                        _showFeedback(ReportType.feedback);
                      },
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    ContentItem(
                      title: "Relatar problema",
                      leading: const Icon(
                        FontAwesomeIcons.triangleExclamation,
                        color: Colors.white,
                      ),
                      onTap: () {
                        _showFeedback(ReportType.problem);
                      },
                    ),
                    const TitleItem(title: "PRIVACIDADE"),
                    ContentItem(
                      title: "Política de privacidade",
                      leading: const Icon(
                        FontAwesomeIcons.fileShield,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.privacyPolicy);
                      },
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    ContentItem(
                      title: "Termos de uso",
                      leading: const Icon(
                        FontAwesomeIcons.fileCircleCheck,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.termsAndConditions);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  _showFeedback(ReportType reportType) {
    return showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: optionFilledColor,
        builder: (ctx) => CustomFeedback(reportType: reportType));
  }
}
