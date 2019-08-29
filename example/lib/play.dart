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
      Text("Select engine:")
    );
  }
}
class PlayControls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(children: <Widget>[
        Text("WASD / Arrow Keys: Apply directional force."),
        Text("Z/X: Apply torque."),
        Text("Hold: Accelerate towards the point selected.")
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
            IconButton(                
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play',
              onPressed: () => Provider.of<ContraptionState>(context, listen: false).play(),
            ),
            IconButton(                
              icon: const Icon(Icons.pause),
              tooltip: 'Pause',
              onPressed: () => Provider.of<ContraptionState>(context, listen: false).pause(),
            ),
            IconButton(                
              icon: const Icon(Icons.replay),
              tooltip: 'Reset',
              onPressed: () => Provider.of<ContraptionState>(context, listen: false).reset(),
            ),
          ],
        ),
        Consumer<GameStatus>(
            builder: (context, status, child) => Text("Running using ${status.engine} at ${status.fps} FPS")
          )
      ],)
    );
  }
}

// DISPLAY
class PlayDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var contraption = Provider.of<ContraptionParameters>(context, listen: false);

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

  ContraptionParameters contraptionParameters;

  PlayPainter(ContraptionParameters contraptionParameters) : super(repaint: contraptionParameters) {
    this.contraptionParameters = contraptionParameters;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    double pointRadius = 3.0;
    var pointPaint = Paint();

    var linePaint = Paint();

    for (var point in contraptionParameters.points){
      canvas.drawCircle(point, pointRadius, pointPaint);
    }

    for (var line in contraptionParameters.lines){
      canvas.drawLine(contraptionParameters.points[line[0]], contraptionParameters.points[line[1]], linePaint);
    }
  }

  @override
  bool shouldRepaint(PlayPainter oldDelegate) => true;
}

