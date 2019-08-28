
import 'package:flutter/material.dart';

class ContraptionPosition with ChangeNotifier {
  var points = <Offset>[];
  var lines = [];

  void spawn(position) {
    points.add(position.relative);

    // Create complete graph connections
    if (points.length > 1){
      int p1 = points.length - 1;

      for (int p2 = 0; p2 < p1; p2++){
        lines.add([p1, p2]);
      }
    }
  }

    notifyListeners();
}
