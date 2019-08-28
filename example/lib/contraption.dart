
import 'package:flutter/material.dart';

class ContraptionPosition with ChangeNotifier {
  double x = 100;
  double y = 200;

  void spawn(position) {
    x = position.relative.dx;
    y = position.relative.dy;
    notifyListeners();
  }
}