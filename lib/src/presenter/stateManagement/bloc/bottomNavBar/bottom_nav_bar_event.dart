// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

import '../../../../core/utils/constants.dart';

class BottomNavBarEvent extends Equatable {
  final PageType page;
  const BottomNavBarEvent({
    required this.page,
  });

  @override
  List<Object> get props => [page.index];
}

class UpdateBottomNavBarEvent extends BottomNavBarEvent {
  const UpdateBottomNavBarEvent({required super.page});
}
