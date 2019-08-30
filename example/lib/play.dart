import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'contraption.dart';

class GameStatus with ChangeNotifier{
  String engine = 'Dart';
  double fps = 60.0;

  void setEngine(String engineName){
    engine = engineName;

    notifyListeners();
  }
}

// TAB
class PlayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[PlayInterface(), PlayDisplay()],
      )
      );
  }
}

// INTERFACE
class PlayInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          PlayEngine(),
          PlayControls(),
          PlayStatus()
      ])
    );
  }
}

class PlayEngine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Text('Select engine:')
    );
  }
}
class PlayControls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(children: <Widget>[
        Text('WASD / Arrow Keys: Apply directional force.'),
        Text('Z/X: Apply torque.'),
        Text('Hold: Accelerate towards the point selected.')
      ])
    );
  }
}

class PlayStatus extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(children: <Widget>[
        Row(
          children: <Widget>[
            Consumer<ContraptionParameters>(builder: (context, parameters, child) =>
              Consumer<Environment>(builder: (context, environment, child) =>
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  tooltip: 'Play',
                  onPressed: () => Provider.of<ContraptionState>(context, listen: false).play(environment, parameters)
                )
              )
            ),
            IconButton(                
              icon: const Icon(Icons.pause),
              tooltip: 'Pause',
              onPressed: () => Provider.of<ContraptionState>(context, listen: false).pause(),
            ),
            Consumer<ContraptionParameters>(
              builder: (context, parameters, child) => IconButton(
                icon: const Icon(Icons.replay),
                tooltip: 'Reset',
                onPressed: () => Provider.of<ContraptionState>(context, listen: false).reset(parameters)
              )
            )
          ],
        ),
        Consumer<GameStatus>(
            builder: (context, status, child) => Text('Running using ${status.engine} at ${status.fps} FPS')
        )
      ],)
    );
  }
}

// DISPLAY
class PlayDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var contraption = Provider.of<ContraptionState>(context, listen: false);

    return CustomPaint(
      painter: PlayPainter(contraption),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        )
      )
    );
  }
}

class PlayPainter extends CustomPainter {

  ContraptionState contraptionState;

  PlayPainter(ContraptionState contraptionState) : super(repaint: contraptionState) {
    this.contraptionState = contraptionState;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    double pointRadius = 3.0;
    var pointPaint = Paint();

    var linePaint = Paint();

    for (var point in contraptionState.points){
      canvas.drawCircle(Offset(point[0], point[1]), pointRadius, pointPaint);
    }

    for (var line in contraptionState.lines){
      double x0 = contraptionState.points[line[0]][0];
      double y0 = contraptionState.points[line[0]][1];

      double x1 =  contraptionState.points[line[1]][0];
      double y1 = contraptionState.points[line[1]][1];

      canvas.drawLine(Offset(x0, y0), Offset(x1, y1), linePaint); 
    }
  }

  @override
  bool shouldRepaint(PlayPainter oldDelegate) => true;
}

