import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorText),
    );
  }
}
