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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          PlayStatus(),
          PlayControls(),
          PlayEngine()
      ])
    );
  }
}

class PlayEngine extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Text('Select engine: Flutter / Julia / DiffEq.jl')
    );
  }
}
// TODO: add hotkey controls
class PlayControls extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Input input = Provider.of<Input>(context, listen: false);

    return(
      Column(children: <Widget>[
        RaisedButton(
          onPressed: () => input.up = !input.up,
          child: Text("Up"),
        ),
        RaisedButton(
          onPressed: () => input.down = !input.down,
          child: Text("Down"),
        ),        
        RaisedButton(
          onPressed: () => input.left = !input.left,
          child: Text("Left"),
        ),        
        RaisedButton(
          onPressed: () => input.right = !input.right,
          child: Text("Right"),
        )
      ])
    );
  }
}

class PlayStatus extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Environment environment = Provider.of<Environment>(context, listen:false);
    ContraptionParameters parameters = Provider.of<ContraptionParameters>(context, listen:false);
    ContraptionState state = Provider.of<ContraptionState>(context, listen:false);
    Input input = Provider.of<Input>(context, listen:false);
    GameStatus status = Provider.of<GameStatus>(context, listen:false);

    return(
      Column(children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Play',
              onPressed: () => state.play(environment, parameters, input)
            ),
            IconButton(                
              icon: const Icon(Icons.pause),
              tooltip: 'Pause',
              onPressed: () => state.pause(),
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              tooltip: 'Reset',
              onPressed: () => state.reset(parameters)
            )
          ],
        ),
        Text('Running using ${status.engine} at ${status.fps} FPS')
      ],)
    );
  }
}

// DISPLAY
class PlayDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var contraptionState = Provider.of<ContraptionState>(context, listen: false);
    var contraptionParameters = Provider.of<ContraptionParameters>(context, listen: false);

    return CustomPaint(
      painter: PlayPainter(contraptionState, contraptionParameters),
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
  ContraptionParameters contraptionParameters;

  PlayPainter(ContraptionState contraptionState, ContraptionParameters contraptionParameters) : super(repaint: contraptionState) {
    this.contraptionState = contraptionState;
    this.contraptionParameters = contraptionParameters;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    var pointPaint = Paint();

    var linePaint = Paint();

    for (int i = 0; i < contraptionState.points.length; i++){
      var point = contraptionState.points[i];
      var radius = contraptionParameters.radius[i.toString()];      
      
      canvas.drawCircle(Offset(point[0], point[1]), radius, pointPaint);
    }

    for (var line in contraptionState.lines){
      int i = line[0];
      int j = line[1];
      double x0 = contraptionState.points[i][0];
      double y0 = contraptionState.points[i][1];

      double x1 = contraptionState.points[j][0];
      double y1 = contraptionState.points[j][1];

      String key = i.toString() + "," + j.toString();
      linePaint.strokeWidth = contraptionParameters.springWidth[key];

      double compressionRatio = contraptionState.dist(i, j) / 
                                contraptionParameters.restLength[key];

      double colorCurve(x){
        // f(1) = 0
        // f(infinity) = 1
        // Monotonically increasing
        // Increases faster near the start
        
        // Derivation:
        //0 = (ax - 1)/x + 0.99
        //a - 1 + 0.99 = 0
        //a = 0.01

        double rate = 10000.0;
        return rate*(0.01*x - 1)/(rate*x) + 0.99; 
      }

      if (compressionRatio == 1){
        linePaint.color = HSLColor.fromAHSL(1.0, 0.0, 0.0, 0.25).toColor();
      } else if (compressionRatio > 1) {
        linePaint.color = HSLColor.fromAHSL(1.0, 0.0, colorCurve(compressionRatio), 0.25).toColor();
      } else {
        linePaint.color = HSLColor.fromAHSL(1.0, 230.0, colorCurve(1/compressionRatio), 0.25).toColor();
      }

      canvas.drawLine(Offset(x0, y0), Offset(x1, y1), linePaint); 
    }
  }

  @override
  bool shouldRepaint(PlayPainter oldDelegate) => true;
}

