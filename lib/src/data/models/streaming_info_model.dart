// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StreamingInfoModel {
  final String code;
  final String url;
  StreamingInfoModel({
    required this.code,
    required this.url,
  });

  StreamingInfoModel copyWith({
    String? code,
    String? url,
  }) {
    return StreamingInfoModel(
      code: code ?? this.code,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'url': url,
    };
  }

  factory StreamingInfoModel.fromMap(Map<String, dynamic> map) {
    return StreamingInfoModel(
      code: map['code'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StreamingInfoModel.fromJson(String source) =>
      StreamingInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StreamingInfoModel(code: $code, url: $url)';

  @override
  bool operator ==(covariant StreamingInfoModel other) {
    if (identical(this, other)) return true;

    return other.code == code && other.url == url;
  }

  @override
  int get hashCode => code.hashCode ^ url.hashCode;
}
