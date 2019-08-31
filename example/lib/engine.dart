import 'contraption.dart';
import 'dart:math';

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

engine(Environment environment, ContraptionParameters parameters, ContraptionState state, double timeStep){
  var newPoints = List.from(state.points);
  var newVelocity = List.from(state.velocity);
  
  // Compute all spring forces in linear time
  var springs = List.generate(newPoints.length, (_) => [0.0, 0.0]);

  for (var connection in parameters.connections){
    int i = connection[0];
    int j = connection[1];
    String key = i.toString() + "," + j.toString();

    double strength = parameters.strength[key];
    double restLength = parameters.restLength[key];
    double massI = parameters.mass[i.toString()];
    double massJ = parameters.mass[j.toString()];

    double distX = newPoints[i][0] - newPoints[j][0];
    double distY = newPoints[i][1] - newPoints[j][1];
    double dist = sqrt(distX*distX + distY*distY);

    double force = -strength*(dist - restLength);
    double forceX = force*distX/dist;
    double forceY = force*distY/dist;

    springs[i][0] += forceX / massI;
    springs[i][1] += forceY / massI;


    springs[j][0] -= forceX / massJ;
    springs[j][1] -= forceY / massJ;
  }

  for (int i = 0; i < newPoints.length; i++){
    var drag = [environment.drag*state.velocity[i][0], 
                environment.drag*state.velocity[i][1]];

    double ax = springs[i][0] - drag[0];
    double ay = springs[i][1] - drag[1] + environment.gravity;

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