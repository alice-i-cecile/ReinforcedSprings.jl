import 'contraption.dart';

collisionCheck(x, y, vx, vy, double elasticity){
  double width = 400.0;
  double height = 400.0;

  double newX = x;
  double newY = y;

  double newVx = vx;
  double newVy = vy;

  return {'x': newX, 'y': newY, 'vx': newVx, 'vy': newVy};
}

engine(Environment environment, ContraptionParameters contraptionParameters, ContraptionState contraptionState, double timeStep){

  var newPoints = contraptionState.points;
  var newVelocity = contraptionState.velocity;
  
  double ax = 0.0;
  double ay = environment.gravity;
  
  for (int i = 0; i < newPoints.length; i++){
    double vx = contraptionState.velocity[i][0] + ax * timeStep;
    double vy = contraptionState.velocity[i][1] + ay * timeStep;

    double x = contraptionState.points[i][0] + vx * timeStep;
    double y = contraptionState.points[i][1] + vy * timeStep;

    var corrected = collisionCheck(x, y, vx, vy, environment.elasticity);
    
    newVelocity[i] = [corrected['vx'], corrected['vy']];
    newPoints[i] = [corrected['x'], corrected['y']];
  }

  return {'points': newPoints, 'velocity': newVelocity};
}