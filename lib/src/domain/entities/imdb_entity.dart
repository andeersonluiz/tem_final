// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Imdb extends Equatable {
  final double rating;
  final DateTime lastUpdate;
  const Imdb({
    required this.rating,
    required this.lastUpdate,
  });

  @override
  List<Object> get props => [rating, lastUpdate];

  @override
  bool? get stringify => true;
}
