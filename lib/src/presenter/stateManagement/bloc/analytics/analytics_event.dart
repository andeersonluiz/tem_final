// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:tem_final/src/core/utils/constants.dart';

class AnalyticsEvent extends Equatable {
  const AnalyticsEvent({this.feedbackParams, this.idTvShowAndMovie});

  final String? idTvShowAndMovie;
  final Tuple3<String, ReportType, String>? feedbackParams;

  @override
  List<Object> get props => [idTvShowAndMovie ?? "", feedbackParams ?? ""];
}

class UpdateViewCountEvent extends AnalyticsEvent {
  const UpdateViewCountEvent({required super.idTvShowAndMovie});
}

class SendFeedbackEvent extends AnalyticsEvent {
  const SendFeedbackEvent({required super.feedbackParams});
}
