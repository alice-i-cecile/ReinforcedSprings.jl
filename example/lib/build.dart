import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';

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
          BuildProperties(),
          BuildTools(),
          BuildComponents()
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
            onPressed: () => Provider.of<ContraptionPosition>(context).mirror(),
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
    var contraption = Provider.of<ContraptionPosition>(context, listen: false);

    return CustomPaint(
      painter: ContraptionPainter(contraption),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        ),
        child: PositionedTapDetector(
          onTap: (position) => contraption.spawn(position)
        )
      )
    );
  }
}

class ContraptionPainter extends CustomPainter {

  ContraptionPosition contraptionPosition;

  ContraptionPainter(ContraptionPosition contraptionPosition) : super(repaint: contraptionPosition) {
    this.contraptionPosition = contraptionPosition;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    double pointRadius = 3.0;
    var pointPaint = Paint();

    var linePaint = Paint();

    for (var point in contraptionPosition.points){
      canvas.drawCircle(point, pointRadius, pointPaint);
    }

    for (var line in contraptionPosition.lines){
      canvas.drawLine(contraptionPosition.points[line[0]], contraptionPosition.points[line[1]], linePaint);
    }
  }

  @override
  bool shouldRepaint(ContraptionPainter oldDelegate) => true;
}