import 'contraption.dart';

collisionCheck(double x, double y, 
               double vx, double vy, 
               double oldX, double oldY, 
               double elasticity, double time){
  double width = 400.0;
  double height = 400.0;

  // Repeatedly resolve collisions until final position is in bounds
  if (!(0 <= x && x <= width) || !(0 <= y && y <= height)){
    double newX = x;
    double newY = y;
  
    // Determine which collision occurs first
    double xTime;
    double yTime;

    if (vx == 0){
      xTime = double.infinity;
    } else if(vx < 0){
      xTime = (0 - oldX)/vx;
    } else {
      xTime = (width - oldX)/vx;
    }

    if (vy == 0){
      yTime = double.infinity;
    } else if(vy < 0){
      yTime = (0 - oldY)/vy;
    } else {
      yTime = (width - oldY)/vy;
    }

    // Resolve the collision
    if (xTime < yTime){
      double collisionX = oldX + vx*xTime;
      double collisionY = oldY + vy*xTime;

      vx *= -elasticity;
      vy *= elasticity;

      newX = collisionX + vx*(time-xTime);
      newY = collisionY + vy*(time-xTime);
      time -= xTime;
    } else {
      double collisionX = oldX + vx*yTime;
      double collisionY = oldY + vy*yTime;

      vx *= elasticity;
      vy *= -elasticity;

      newX = collisionX + vx*(time-yTime);
      newY = collisionY + vy*(time-yTime);
      time -= yTime;
    }

    // Check that the solution is valid
    var solution = collisionCheck(newX, newY, vx, vy, x, y, elasticity, time);

    x = solution['x'];
    y = solution['y'];
    vx = solution['vx'];
    vy = solution ['vy'];
  }

  return {'x': x, 'y': y, 'vx': vx, 'vy': vy};
}

engine(Environment environment, ContraptionParameters contraptionParameters, ContraptionState contraptionState, double timeStep){
  var state = contraptionState;
  var newPoints = contraptionState.points;
  var newVelocity = contraptionState.velocity;
  
  springAcceleration(nodeID){
    var a = [0.0, 0.0];

    return a;
  }
  
  for (int i = 0; i < newPoints.length; i++){
    var springs = springAcceleration(i);
    var drag = [environment.drag*state.velocity[i][0], 
                environment.drag*state.velocity[i][1]];

    double ax = springs[0] - drag[0];
    double ay = springs[1] - drag[1] + environment.gravity;

    double vx = state.velocity[i][0] + ax * timeStep;
    double vy = state.velocity[i][1] + ay * timeStep;

    double x = state.points[i][0] + vx * timeStep;
    double y = state.points[i][1] + vy * timeStep;

    var corrected = collisionCheck(x, y, vx, vy,
                                   state.points[i][0], state.points[i][1],
                                   environment.elasticity, timeStep);
  
    newVelocity[i] = [corrected['vx'], corrected['vy']];
    newPoints[i] = [corrected['x'], corrected['y']];
  }

  return {'points': newPoints, 'velocity': newVelocity};
}