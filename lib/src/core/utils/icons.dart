import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tem_final/src/core/resources/custom_icons.dart';

generateIconAgeClassification(String ageClassification) {
  switch (ageClassification) {
    case "L":
      return CustomIcons.L;
    case "10":
      return CustomIcons.teen;
    case "12":
      return CustomIcons.twelve;
    case "14":
      return CustomIcons.fourteen;
    case "16":
      return CustomIcons.sixteen;
    case "18":
      return CustomIcons.eighteen;
  }
}

var regex1 = RegExp(r'[A-D]');
var regex2 = RegExp(r'[E-H]');
var regex3 = RegExp(r'[I-L]');
var regex4 = RegExp(r'[M-P]');
var regex5 = RegExp(r'[Q-T]');
var regex6 = RegExp(r'[U-Z]');

generateIconProfile(String username) {
  String firstLetter = username[0].toUpperCase();
  if (regex1.hasMatch(firstLetter)) {
    return noHasFinalIcon;
  } else if (regex2.hasMatch(firstLetter)) {
    return hasFinalIcon;
  } else if (regex3.hasMatch(firstLetter)) {
    return openedIcon;
  } else if (regex4.hasMatch(firstLetter)) {
    return closedIcon;
  } else if (regex5.hasMatch(firstLetter)) {
    return newSeasonIcon;
  } else if (regex6.hasMatch(firstLetter)) {
    return noNewSeasonIcon;
  } else {
    return newSeasonIcon;
  }
}

const kFirstIconSizeOverlay = 45.0;
const kSecondIconSizeOverlay = 15.0;
const kSelectFirstIconSize = 60.0;
const kUnselectFirstIconSize = 30.0;
const kIconSizeOption = 35.0;
const kIconSizeCard = 15.0;

const noHasFinalIcon = FontAwesomeIcons.xmark;
const hasFinalIcon = FontAwesomeIcons.check;
const openedIcon = FontAwesomeIcons.unlock;
const closedIcon = FontAwesomeIcons.lock;
const newSeasonIcon = FontAwesomeIcons.fire;
const noNewSeasonIcon = Icons.ac_unit;
