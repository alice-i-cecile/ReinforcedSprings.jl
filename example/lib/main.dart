import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(MaterialApp(
    home: ChangeNotifierProvider(
      builder: (context) => ContraptionPosition(),
      child: ModeTabs(),
    )
  ));
}

class ContraptionPosition with ChangeNotifier {
  double x = 100;
  double y = 200;

  void spawn(position) {
    print(position);
    x = position.relative.dx;
    y = position.relative.dy;
    notifyListeners();
  }
}

class ModeTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("My Contraption"),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'New Contraption',
                onPressed: (){},
              ),
              IconButton(
                icon: const Icon(Icons.folder_open),
                tooltip: 'Load Contraption',
                onPressed: (){},
              ),
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Contraption',
                onPressed: (){},
              ),
              IconButton(
                icon: const Icon(Icons.help),
                tooltip: 'Help',
                onPressed: (){},
              ),

            ], 
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit)),
                Tab(icon: Icon(Icons.toys)),
                Tab(icon: Icon(Icons.lightbulb_outline)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              BuildTab(),
              PlayTab(),
              LearnTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class BuildTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          BuildInterface(), 
          BuildDisplay()],
      )
    );
  }
}

class BuildProperties extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        children: <Widget>[
          Row(children: <Widget>[
            Text("Mass", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: 1.0,
              max: 100.0,
              label: "currentMass",
              onChanged: (newMass) {}),
          ]),
          Row(children: <Widget>[
            Text("Spring Strength", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: 1.0,
              max: 100.0,
              label: "currentStrength",
              onChanged: (newStrength) {}),
          ]),
          Row(children: <Widget>[
            Text("Gravity", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: -100.0,
              value: 10.0,
              max: 100.0,
              label: "currentGravity",
              onChanged: (newStrength) {}),
          ]),
          Row(children: <Widget>[
            Text("Elasticity", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: 0.4,
              max: 1.0,
              label: "currentElasticity",
              onChanged: (newStrength) {}),
          ]),
          Row(children: <Widget>[
            Text("Drag", style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: 0.4,
              max: 1.0,
              label: "currentDrag",
              onChanged: (newDrag) {}),
          ]),
        ]
      )
    );
  }
}

class BuildTools extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(children: <Widget>[
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.near_me),
            tooltip: 'Select',
            onPressed: (){},
          ),
          IconButton(                
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: (){},
          ),
        ],),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.rotate_right),
            tooltip: 'Rotate',
            onPressed: (){},
          ),
          IconButton(                
            icon: const Icon(Icons.flip),
            tooltip: 'Mirror',
            onPressed: (){},
          ),
        ]),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.share),
            tooltip: 'Connect',
            onPressed: (){},
          ),
          IconButton(                
            icon: const Icon(Icons.scatter_plot),
            tooltip: 'Disconnect',
            onPressed: (){},
          ),
        ],),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: (){},
          ),
          IconButton(                
            icon: const Icon(Icons.redo),
            tooltip: 'Redo',
            onPressed: (){},
          ),
        ],)
      ])
    );
  }
}
class BuildComponents extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Point"),
        Text("Spring")
      ],
    );
  }
}

class BuildInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Properties
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0, color: Colors.black),
              ),
            ),
            child: BuildProperties()
          ),
          // Tools
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0, color: Colors.black),
              ),
            ),
            child: BuildTools()
          ),
          // Components
          Container(
              child: BuildComponents()
          ),
        ]
      )
    );
  }
}

class BuildDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return(
      Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        ),
        child: PositionedTapDetector(
          child: Consumer<ContraptionPosition>(
            builder: (context, contraption, child) => Text('${contraption.x}, ${contraption.y}')
          ),
          onTap: (position) => Provider.of<ContraptionPosition>(context, listen: false).spawn(position)
        )
      )
    );
  }
}
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

class LearnTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[LearnInterface(), Display()],
      )
    );
  }
}


class LearnInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Behaviours"), 
          Text("Goals"),
          Text("Learning Strategy"),
          Text("Control 4"),
          Text("Control 5"),
        ]
      )
    );
  }
}

class Display extends StatelessWidget{
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
