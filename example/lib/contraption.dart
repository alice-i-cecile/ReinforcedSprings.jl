
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

    notifyListeners();
  }

  void mirror(){
    double center = 200.0;
    
    for (int i = 0; i < points.length; i++){
      // Distance between center and initial position is c - x
      // Distance between center and final position must be the same
      // Thus c + (c-x) gives the final position
      points[i] = Offset(2*center - points[i].dx, points[i].dy);
    }

    notifyListeners();
  }
}
