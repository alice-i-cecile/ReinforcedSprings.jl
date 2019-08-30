import 'package:flutter/gestures.dart';

import 'contraption.dart';

engine(Environment environment, ContraptionParameters contraptionParameters, ContraptionState contraptionState, double timeStep){

  var newPoints = contraptionState.points;
  var newVelocity = contraptionState.velocity;
  
  var acceleration = [0, environment.gravity];
  
  for (int i = 0; i < newPoints.length; i++){
    newVelocity[i] = [acceleration[0] * timeStep, 
                       acceleration[1] * timeStep];

    newPoints[i] += Offset(newVelocity[i][0] * timeStep,
                           newVelocity[i][1] * timeStep);
  }

  return {'points': newPoints, 'velocity': newVelocity};
}