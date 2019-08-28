import 'package:flutter/material.dart';

// TAB
class PlayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[PlayInterface(), Display()],
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
          // Engine
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0, color: Colors.black),
              ),
            ),
            child: PlayEngine()
          ),
          // Controls
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0, color: Colors.black),
              ),
            ),
            child: PlayControls()
          ),
          // Status
          Container(
              child: PlayStatus()
          ),
        ]
      )
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
              onPressed: (){},
            ),
            IconButton(                
              icon: const Icon(Icons.pause),
              tooltip: 'Pause',
              onPressed: (){},
            ),
            IconButton(                
              icon: const Icon(Icons.replay),
              tooltip: 'Restart',
              onPressed: (){},
            ),
          ],
        ),
        Text("FPS: ??")
      ],)
    );
  }
}

// DISPLAY
class PlayDisplay extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        ),
      )
    );
  }
}
