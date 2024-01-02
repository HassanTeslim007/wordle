import 'package:flutter/material.dart';

SizedBox ySpace(height) {
  return SizedBox(
    height: height.toDouble(),
  );
}

// Used to give horizontal Spaces
SizedBox xSpace(width) {
  return SizedBox(
    width: width.toDouble(),
  );
}

extension StringExtension on String {
  bool isDigit() {
    try {
      double.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
