import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';

import 'contraption.dart';

class Tool with ChangeNotifier{
  String selectedTool = "Node";

  void changeTool(String toolName){
    selectedTool = toolName;

    notifyListeners();
  }
}

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
          BuildComponents(),
          Consumer<Tool>(
            builder: (context, tool, child) => Text("Tool: ${tool.selectedTool}")
          )
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
            onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Select'),
          ),
          IconButton(                
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Delete'),
          ),
        ],),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.rotate_right),
            tooltip: 'Rotate',
            onPressed: () => Provider.of<ContraptionPosition>(context, listen: false).rotate(3.14159/6.0),
          ),
          IconButton(                
            icon: const Icon(Icons.flip),
            tooltip: 'Mirror',
            onPressed: () => Provider.of<ContraptionPosition>(context, listen: false).mirror(),
          ),
        ]),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.share),
            tooltip: 'Connect',
            onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Connect'),
          ),
          IconButton(                
            icon: const Icon(Icons.scatter_plot),
            tooltip: 'Disconnect',
            onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Disconnect'),
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
        RaisedButton(
          onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Node'),
          child: Text("Node")),
        RaisedButton(
          onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Spring'),
          child: Text("Spring"))
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
      painter: BuildPainter(contraption),
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

class BuildPainter extends CustomPainter {

  ContraptionPosition contraptionPosition;

  BuildPainter(ContraptionPosition contraptionPosition) : super(repaint: contraptionPosition) {
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
  bool shouldRepaint(BuildPainter oldDelegate) => true;
}