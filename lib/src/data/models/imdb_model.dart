// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ImdbModel {
  final double rating;
  final DateTime lastUpdate;
  ImdbModel({
    required this.rating,
    required this.lastUpdate,
  });

  ImdbModel copyWith({
    double? rating,
    DateTime? lastUpdate,
  }) {
    return ImdbModel(
      rating: rating ?? this.rating,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rating': rating,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  factory ImdbModel.fromMap(Map<String, dynamic> map) {
    return ImdbModel(
      rating: map['rating'] as double,
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(map['lastUpdate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImdbModel.fromJson(String source) =>
      ImdbModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ImdbModel(rating: $rating, lastUpdate: $lastUpdate)';

  @override
  bool operator ==(covariant ImdbModel other) {
    if (identical(this, other)) return true;

    return other.rating == rating && other.lastUpdate == lastUpdate;
  }

  @override
  int get hashCode => rating.hashCode ^ lastUpdate.hashCode;
}
