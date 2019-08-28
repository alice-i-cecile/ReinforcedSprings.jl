import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'contraption.dart';


// TAB
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

// INTERFACE
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

// DISPLAY
class BuildDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return(
      CustomPaint(
        painter: Sky(),
        child: Container(
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
      )
    );
  }
}

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    var gradient = RadialGradient(
      center: const Alignment(0.7, -0.6),
      radius: 0.2,
      colors: [const Color(0xFFFFFF00), const Color(0xFF0099FF)],
      stops: [0.4, 1.0],
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient.createShader(rect),
    );
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}