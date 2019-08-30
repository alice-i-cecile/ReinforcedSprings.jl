
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

import 'engine.dart';

class ContraptionParameters with ChangeNotifier {
  var nodes = [];
  var connections = Set();

  void blank(){
    nodes = [];
    connections = Set();

    notifyListeners();
  }

  void node(position) {
    nodes.add([position.dx, position.dy]);

    notifyListeners();
  }

  void spring(int node1, int node2){
    connections.add([node1, node2]);

    notifyListeners();
  }

  void delete(Set<int> selected){
    var newNodes = [];

    for (int i = 0; i < nodes.length; i++){
      if (!selected.contains(i)){
        newNodes.add(nodes[i]);
      }
    }
    nodes = newNodes;

    var newConnections = Set();
    for (var connection in connections){
      if (!(selected.contains(connection[0]) || 
            selected.contains(connection[1]))){
        newConnections.add(connection);
      }
    } 

    connections = newConnections;

    notifyListeners();
  }

  void mirror(Set<int> selected){
    double width = 400.0;
    double sumX = 0.0;
    int n = selected.length;

    if (selected.length == 0){
      n = nodes.length;
      for (int i = 0; i < nodes.length; i++){
        sumX += nodes[i][0];
      }
    } else {
      for (int i = 0; i < nodes.length; i++){
        if (selected.contains(i)){
          sumX += nodes[i][0];
        }
      }
    }

    double center = sumX/n;
    
    for (int i = 0; i < nodes.length; i++){
      // Distance between center and initial position is c - x
      // Distance between center and final position must be the same
      // Thus c + (c-x) gives the final position
      if (selected.length == 0 || selected.contains(i)){
        double newX = 2*center - nodes[i][0];

        if (newX < 0){
          newX = 0;
        } else if (newX > width){
          newX = width;
        }
        
        nodes[i] = [newX, nodes[i][1]];
      }
    }

    notifyListeners();
  }

  void rotate(angle, Set<int> selected){
    double width = 400.0;
    double height = 400.0;
    double sumX = 0.0;
    double sumY = 0.0;
    int n = selected.length;

    if (selected.length == 0){
      n = nodes.length;
      for (int i = 0; i < nodes.length; i++){
        sumX += nodes[i][0];
        sumY += nodes[i][1];
      }
    } else {
      for (int i = 0; i < nodes.length; i++){
        if (selected.contains(i)){
          sumX += nodes[i][0];
          sumY += nodes[i][1];
        }
      }
    }

    double cx = sumX/n;
    double cy = sumY/n;
    
    for (int i = 0; i < nodes.length; i++){
      if (selected.length == 0 || selected.contains(i)){
        double dx = nodes[i][0];
        double dy = nodes[i][1];

        double rx = cos(angle) * (dx - cx) - sin(angle) * (dy - cy) + cx;
        double ry = sin(angle) * (dx - cx) + cos(angle) * (dy - cy) + cy;

        if (rx < 0){
          rx = 0;
        } else if (rx > width){
          rx = width;
        }

        if (ry < 0){
          ry = 0;
        } else if (ry > height){
          ry = height;
        }

        nodes[i] = [rx, ry];
      }
    }

    notifyListeners();
  }

  void connect(Set<int> selected){
    if (selected.length == 0){
      int n = nodes.length;
      for (int i = 0; i < n; i++){
        for (int j = 0; j < i; j++){
          connections.add([i, j]);
        }
      }
    } else {
      for (int i in selected){
        for (int j in selected){
          if (i > j){
            connections.add([i, j]);
          }
        }
      }
    }

    notifyListeners();
  }

  void disconnect(Set<int> selected){
    if (selected.length == 0){
      connections = Set();
    } else {
      var newConnections = Set();
      
      for (var connection in connections){
        if (!(selected.contains(connection[0]) && 
              selected.contains(connection[1]))){
              newConnections.add(connection);
            }
      }

      connections = newConnections;
    }

    notifyListeners();
  }

  void translate(position, Set<int> selected){
    double width = 400.0;
    double height = 400.0;

    int n = selected.length;
    if (n == 0){
      n = nodes.length;
    }

    double sumX = 0.0;
    double sumY = 0.0;
    for (int i = 0; i < nodes.length; i++){
      if (selected.contains(i) || selected.length == 0){
        sumX += nodes[i][0];
        sumY += nodes[i][1];
      }
    }

    var center = [sumX/n, sumY/n];
    var shift = [position.dx - center[0], position.dy - center[1]];

    for (int i = 0; i < nodes.length; i++){
      if (selected.contains(i) || selected.length == 0){
        double newX = nodes[i][0] + shift[0];
        double newY = nodes[i][1] + shift[1];

        if (newX < 0) {
          newX = 0;
        } else if (newX > width){
          newX = width;
        }

        if (newY < 0) {
          newY = 0;
        } else if (newY > height){
          newY = height;
        }

        nodes[i] = [newX, newY];
      }
    }

    notifyListeners();
  }
}

class ContraptionState with ChangeNotifier{
  var points = [];
  var lines = Set();
  var velocity = [];

  // TODO: reset not working. State seems to be leaking
  void reset(ContraptionParameters contraptionParameters){
    this.pause();

    this.points = contraptionParameters.nodes;
    this.lines = contraptionParameters.connections;
    this.velocity = List.filled(points.length, [0.0, 0.0]);

    notifyListeners();
  }

  void play(Environment environment, ContraptionParameters contraptionParameters){
    int timeStep = 50;
    Timer.periodic(Duration(milliseconds: timeStep),
    (timer){
      simulate(environment, contraptionParameters, timeStep.toDouble()/1000);
    });
  }

  void simulate(Environment environment, ContraptionParameters contraptionParameters, double timeStep){
    if (velocity.length != 0){
      var newState = engine(environment, contraptionParameters, this, timeStep);
      this.points = newState['points'];
      this.velocity = newState['velocity'];

      notifyListeners();
    }
  }

  void pause(){

    notifyListeners();
  }
}

class Environment with ChangeNotifier{
  double gravity = 10;
  double drag = 0.01;
  double elasticity = 0.8;
}