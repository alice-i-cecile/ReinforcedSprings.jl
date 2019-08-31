import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';

import 'contraption.dart';

// STATE
class Tool with ChangeNotifier{
  String selectedTool = 'Node';

  void changeTool(String toolName){
    selectedTool = toolName;

    notifyListeners();
  }
}

class Selection with ChangeNotifier{
  Set<int> selectedNodes = Set();

  void clearSelection(){
    selectedNodes = Set();

    notifyListeners();
  }

  void select(nodeNum){
    // Select if new, deselect otherwise
    if (!selectedNodes.contains(nodeNum)){
      selectedNodes.add(nodeNum);
    } else {
      selectedNodes.remove(nodeNum);
    }

    notifyListeners();
  }
}

// Interaction
void buildGesture(ContraptionParameters contraption, Offset position, String tool, Selection selection){
  double distance(aX, aY, bX, bY){
    double d = (aX - bX)*(aX - bX) + 
               (aY - bY)*(aY - bY);
    return d;
  }

  switch(tool) {
    case 'Node': {
      contraption.node(position);
      break;
    }
    case 'Spring': {
      if (contraption.nodes.length >= 2){
        var nodes = contraption.nodes;
        double first = distance(nodes[0][0], nodes[0][1], position.dx, position.dy);
        double second = distance(nodes[1][0], nodes[1][1], position.dx, position.dy);
        int node1 = 0;
        int node2 = 1;

        // Node1 is always the closest node found
        if (first > second){
          var temp = first;
          first = second;
          second = temp;

          var tempNode = node1;
          node1 = node2;
          node2 = tempNode;
        }

        for (int i = 1; i < nodes.length; i++){
          double current = distance(nodes[i][0], nodes[i][1], position.dx, position.dy);
          if (current < second){
            if (current < first){
              second = first;
              node2 = node1;

              first = current;
              node1 = i;
            } else {
              second = current;
              node2 = i;
            }
          }
        } 

        contraption.spring(node1, node2);
      }

      break;
    }
    case 'Select': {
      if (contraption.nodes.length >= 1){
        var nodes = contraption.nodes;
            
        // Find nearest node to tapped position
        double min = distance(nodes[0][0], nodes[0][1], position.dx, position.dy);
        int nodeNum = 0;

        for (int i = 1; i < nodes.length; i++){
          double current = distance(nodes[i][0], nodes[i][1], position.dx, position.dy);
          if (current < min){
            nodeNum = i;
            min = current;
          }
        } 

        //selection.selectedNodes.add(nodeNum);
        selection.select(nodeNum);    
      }

      break;
    }
    case 'Transform': {
      contraption.translate(position, selection.selectedNodes);
      break;
    }
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
          Row(children: <Widget>[
            BuildTools(),
            BuildComponents()
          ]),
          Consumer<Tool>(
            builder: (context, tool, child) => Text('Tool: ${tool.selectedTool}')
          )
        ]
      )
    );
  }
}

// TODO: connect sliders
class BuildProperties extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        children: <Widget>[
          Row(children: <Widget>[
            Text('Mass', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: Provider.of<ContraptionParameters>(context).mass,
              max: 100.0,
              label: 'currentMass',
              onChanged: (newMass) => Provider.of<ContraptionParameters>(context, listen: false).setMass(newMass)
            ),          
          ]),
          Row(children: <Widget>[
            Text('Spring Strength', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: Provider.of<ContraptionParameters>(context).strength,
              max: 100.0,
              label: 'currentStrength',
              onChanged: (newStrength) => Provider.of<ContraptionParameters>(context, listen: false).setStrength(newStrength)
            ),
          ]),
          Row(children: <Widget>[
            Text('Relative Rest Length', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.01,
              value: Provider.of<ContraptionParameters>(context).restLength,
              max: 100.0,
              label: 'currentRestLength',
              onChanged: (newRestLength) => Provider.of<ContraptionParameters>(context, listen: false).setRestLength(newRestLength)
            ),          
          ]),
          Row(children: <Widget>[
            Text('Gravity', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: Provider.of<Environment>(context).gravity,
              max: 100.0,
              label: 'currentGravity',
              onChanged: (newGravity) => Provider.of<Environment>(context, listen: false).setGravity(newGravity)
            ),
          ]),
          Row(children: <Widget>[
            Text('Elasticity', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: Provider.of<Environment>(context).elasticity,
              max: 1.0,
              label: 'currentElasticity',
              onChanged: (newElasticity) => Provider.of<Environment>(context, listen: false).setElasticity(newElasticity)
            ),
          ]),
          Row(children: <Widget>[
            Text('Drag', style: TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              min: 0.0,
              value: Provider.of<Environment>(context).drag,
              max: 1.0,
              label: 'currentDrag',
              onChanged: (newDrag) => Provider.of<Environment>(context, listen: false).setDrag(newDrag)
            ),
          ]),
        ]
      )
    );
  }
}

// TODO: add ability to rotate and flip in alternate directions
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
            icon: const Icon(Icons.close),
            tooltip: 'Clear Selection',
            onPressed: () => Provider.of<Selection>(context, listen: false).clearSelection(),
          ),
        ],),
        Row(children: <Widget>[
          Consumer<Selection>(
            builder: (context, selection, child) => IconButton(
              icon: const Icon(Icons.rotate_right),
              tooltip: 'Rotate',
              onPressed: () => Provider.of<ContraptionParameters>(context, listen: false).rotate(3.14159/6.0, selection.selectedNodes)
            )
          ),
          Consumer<Selection>(
            builder: (context, selection, child) => IconButton(
              icon: const Icon(Icons.flip),
              tooltip: 'Mirror',
              onPressed: () => Provider.of<ContraptionParameters>(context, listen: false).mirror(selection.selectedNodes)
            )
          ),
        ]),
        Row(children: <Widget>[
          Consumer<Selection>(
            builder: (context, selection, child) => IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Connect',
              onPressed: () => Provider.of<ContraptionParameters>(context, listen: false).connect(selection.selectedNodes)
            ),
          ),
          Consumer<Selection>(
            builder: (context, selection, child) => IconButton(
              icon: const Icon(Icons.scatter_plot),
              tooltip: 'Disconnect',
              onPressed: () => Provider.of<ContraptionParameters>(context, listen: false).disconnect(selection.selectedNodes)
            ),
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
          )
        ]),
        Row(children: <Widget>[
          IconButton(
            icon: const Icon(Icons.transform),
            tooltip: 'Transform',
            onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Transform')
          ),
          Consumer<Selection>(
            builder: (context, selection, child) => IconButton(                
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: (){
                Provider.of<ContraptionParameters>(context, listen: false).delete(selection.selectedNodes);
                selection.clearSelection();
                }
                ,
            ),
          )
        ])
      ])
    );
  }
}

// TODO: add regular polygons
class BuildComponents extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Node'),
          child: Text('Node')),
        RaisedButton(
          onPressed: () => Provider.of<Tool>(context, listen: false).changeTool('Spring'),
          child: Text('Spring'))
      ],
    );
  }
}

// DISPLAY
class BuildDisplay extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var contraption = Provider.of<ContraptionParameters>(context, listen: false);
    var selected = Provider.of<Selection>(context, listen: false);

    return CustomPaint(
      painter: BuildPainter(contraption, selected),
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        ),
        child: Consumer<Tool>(
          builder: (context, tool, child) => Consumer<Selection>(
            builder: (context, selection, child) => PositionedTapDetector(
              onTap: (position) => buildGesture(contraption, position.relative, tool.selectedTool, selection)
            )
          )
        )
      )
    );
  }
}

class BuildPainter extends CustomPainter {
  ContraptionParameters contraptionParameters;
  Selection selection;

  BuildPainter(ContraptionParameters contraptionParameters, Selection selection) : super(repaint: Listenable.merge([contraptionParameters, selection])) {
    this.contraptionParameters = contraptionParameters;
    this.selection = selection;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    double pointRadius = 3.0;
    var pointPaint = Paint();
    var selectPaint = Paint();

    var linePaint = Paint();

    var selected = selection.selectedNodes;

    for (int i = 0; i < contraptionParameters.nodes.length; i++){
      var point = contraptionParameters.nodes[i];
      
      if (selected.contains(i)) {
        canvas.drawCircle(Offset(point[0], point[1]), 1.5 * pointRadius, selectPaint);
      } else {
        canvas.drawCircle(Offset(point[0], point[1]), pointRadius, pointPaint);
      }
    }

    for (var line in contraptionParameters.connections){
      double x0 = contraptionParameters.nodes[line[0]][0];
      double y0 = contraptionParameters.nodes[line[0]][1];

      double x1 =  contraptionParameters.nodes[line[1]][0];
      double y1 = contraptionParameters.nodes[line[1]][1];

      canvas.drawLine(Offset(x0, y0), Offset(x1, y1), linePaint); 
    }
  }

  @override
  bool shouldRepaint(BuildPainter oldDelegate) => true;
}