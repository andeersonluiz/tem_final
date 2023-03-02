import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/presenter/reusableWidgets/custom_button.dart';
import 'package:tem_final/src/presenter/reusableWidgets/loading_widget.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_bloc.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_event.dart';
import 'package:tem_final/src/presenter/stateManagement/bloc/user/user_state.dart';

class LoginDialogPage extends StatelessWidget {
  const LoginDialogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = context.read<UserBloc>();
    return FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1000)),
        builder: (ctx, snp) {
          if (snp.connectionState == ConnectionState.done) {
            return AlertDialog(
              title: const Center(
                  child: Text(
                "Bem vindo ao Tem Final",
                style: TextStyle(
                    fontFamily: fontFamily,
                    color: ratingColorPosterMainPage,
                    fontSize: 23,
                    fontWeight: FontWeight.bold),
              )),
              backgroundColor: foregroundColor,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26)),
              content:
                  BlocBuilder<UserBloc, UserState>(builder: (context, state) {
                if (state is UserLoggedDone) {
                  CustomToast(msg: state.msg!);
                  userBloc.add(LoadUserEvent());
                  Navigator.of(context).pop();
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Faça o login ou cadastra-se",
                            style: TextStyle(
                                fontFamily: fontFamily,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: 100.w,
                      height: 90,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Logo(
                              Logos.google,
                              size: 30,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            minLeadingWidth: 4,
                            title: const AutoSizeText(
                                "Login/Cadastro com Google",
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: fontFamily,
                                    color: Colors.black,
                                    fontSize: 14)),
                            onTap: () {
                              userBloc.add(LoginUserEvent());
                            },
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 0.7,
                      ),
                    ),
                    Container(
                      width: 100.h,
                      height: 60,
                      padding: const EdgeInsets.all(8),
                      child: CustomButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: "Voltar"),
                    ),
                  ],
                );
              }),
            );
          } else {
            return const CustomLoadingWidget();
          }
        });
  }
}
