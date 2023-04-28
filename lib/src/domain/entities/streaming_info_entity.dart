import 'package:equatable/equatable.dart';

class StreamingInfo extends Equatable {
  const StreamingInfo({
    required this.code,
    required this.url,
  });
  final String code;
  final String url;

  @override
  List<Object> get props => [code, url];
}
