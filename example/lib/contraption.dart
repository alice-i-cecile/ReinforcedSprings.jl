
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'engine.dart';

class ContraptionParameters with ChangeNotifier {
  var points = <Offset>[];
  var lines = [];

  void blank(){
    points = <Offset>[];
    lines = [];

    notifyListeners();
  }

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

  void rotate(angle){
    double cx = 200.0;
    double cy = 200.0;
    
    for (int i = 0; i < points.length; i++){
      double dx = points[i].dx;
      double dy = points[i].dy;

      double rx = cos(angle) * (dx - cx) - sin(angle) * (dy - cy) + cx;
      double ry = sin(angle) * (dx - cx) + cos(angle) * (dy - cy) + cy;

      points[i] = Offset(rx, ry);
    }

    notifyListeners();
  }
}

class ContraptionState with ChangeNotifier{
  var points = <Offset>[];
  var lines = [];
  var velocity = [];

  // TODO: get appropriate context
  var context;

  //var environment = Provider.of<Environment>(context);
  //var contraptionParameters = Provider.of<ContraptionParameters>(context);

  void reset(){
    this.pause();

    //points = contraptionParameters.points;
    //lines = contraptionParameters.lines;
    //velocity = [[0.0, 0.0] for int i in 1:points.length];

    notifyListeners();
  }

  void play(){
    // Start a timer that repeats itself

    //var newState = engine(environment, contraptionParameters, this);
    //points = newState['points'];
    //velocity = newState['velocity'];

    notifyListeners();
  }

  void pause(){

  }
}

class Environment with ChangeNotifier{
  double gravity = 10;
  double drag = 0.01;
  double elasticity = 0.1;
}