import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:tem_final/src/core/resources/my_behavior.dart';
import 'package:tem_final/src/core/utils/fonts.dart';
import 'package:tem_final/src/core/utils/html_data.dart';
import 'package:tem_final/src/presenter/reusableWidgets/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Termos de uso"),
      ),
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Html(
              data: htmlTermOfConditions,
              onLinkTap: (link, _, __, ___) {
                _launchUrl(link!);
              },
              style: {
                "p": Style(
                    color: Colors.white,
                    fontFamily: fontFamily,
                    textAlign: TextAlign.justify,
                    fontSize: FontSize.large),
                "li": Style(
                    color: Colors.white,
                    fontFamily: fontFamily,
                    textAlign: TextAlign.justify,
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.large),
                "a": Style(
                    fontFamily: fontFamily,
                    textAlign: TextAlign.justify,
                    margin: Margins.all(2.0),
                    textDecoration: TextDecoration.underline,
                    fontSize: FontSize.large),
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      CustomToast(
          msg: 'Não foi possivel abrir o link, tente novamente mais tarde');
    }
  }
}
