import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';
import 'dart:math';

import 'contraption.dart';

// STATE
class Tool with ChangeNotifier{
  String selectedTool = 'Node';
  Offset point1;
  Offset point2;

  int nPolygon = 5;
  double radiusPolygon = 100.0;
  Set<int> connectivityPolygon = Set();

  ContraptionParameters clipboard = ContraptionParameters();

  void changeTool(String toolName){
    selectedTool = toolName;

    point1 = null;
    point2 = null;

    notifyListeners();
  }

  void nPolygonUpdate(int value){
    nPolygon = value;
    notifyListeners();
  }

  void radiusPolygonUpdate(double value){
    radiusPolygon = value;
    notifyListeners();
  }

  void connectivityPolygonUpdate(int value){
    if (!connectivityPolygon.contains(value)){
      connectivityPolygon.add(value);
    } else {
      connectivityPolygon.remove(value);
    }
    notifyListeners();
  }

  void copy(Set<int> selected, ContraptionParameters parameters){
    clipboard = parameters.copy(selected);

    notifyListeners();
  }

  Widget toolIcon(String toolName){
    Widget icon;
    switch(toolName){
      case 'Node': {
        icon = Text('Node');
        break;
      }
      case 'Spring': {
        icon = Text('Spring');
        break;
      }
      case 'RegularPolygon': {
        icon = Text('RegularPolygon');
        break;
      }
      case 'Select': {
        icon = Icon(Icons.near_me);
        break;
      }
      case 'SelectRegion': {
        icon = Icon(Icons.crop_free);
        break;
      }
      case 'Paste': {
        icon = Icon(Icons.content_paste);
        break;
      }
      case 'Transform': {
        icon = Icon(Icons.transform);
        break;
      }
    }

    return icon;
  }
}

class Selection with ChangeNotifier{
  Set<int> selectedNodes = Set();

  void selectAll(ContraptionParameters contraptionParameters){
    selectedNodes = Set();
    for (int i in contraptionParameters.nodes.keys){
      selectedNodes.add(i);
    }

    notifyListeners();
  }

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
void buildGesture(ContraptionParameters contraption, Offset position, Tool tool, Selection selection){
  double distance(aX, aY, bX, bY){
    double d = (aX - bX)*(aX - bX) + 
               (aY - bY)*(aY - bY);
    return d;
  }

  switch(tool.selectedTool) {
    case 'Node': {
      contraption.node(position.dx, position.dy);
      break;
    }
    // TODO: change spring tool to work as users expect
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

        for (int i in nodes.keys){
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

        for (int i in nodes.keys){
          double current = distance(nodes[i][0], nodes[i][1], position.dx, position.dy);
          if (current < min){
            nodeNum = i;
            min = current;
          }
        } 

        selection.select(nodeNum);    
      }

      break;
    }
    case 'RegularPolygon': {
      var center = [position.dx, position.dy];
      double x;
      double y;
      double angle = 0.0;
      double slice = 2* pi / tool.nPolygon;
      int initial = contraption.nodes.length;

      for (int i = initial; i < initial + tool.nPolygon; i++){
        angle += slice;
        x = center[0] + tool.radiusPolygon * cos(angle);
        y = center[1] + tool.radiusPolygon * sin(angle);

        var p = boundsSanitize(x, y);
        contraption.node(p[0], p[1]);
        selection.select(i);
      }

      for (int i = initial; i < initial + tool.nPolygon; i++){
        for (int c in tool.connectivityPolygon){
          int j = i + c;
          while (j > initial + tool.nPolygon - 1){
            j -= tool.nPolygon;
          }
          contraption.spring(i, j);
        }
      }

      break;
    }
    // TODO: add visual indicator of selected region
    case 'SelectRegion': {
      if (tool.point1 == null){
        tool.point1 = position;
      } else {
        tool.point2 = position;
        double xMin;
        double xMax;
        double yMin;
        double yMax;

        if (tool.point1.dx < tool.point2.dx){
          xMin = tool.point1.dx;
          xMax = tool.point2.dx;
        } else {
          xMin = tool.point2.dx;
          xMax = tool.point1.dx;
        }

        if (tool.point1.dy < tool.point2.dy){
          yMin = tool.point1.dy;
          yMax = tool.point2.dy;
        } else {
          yMin = tool.point2.dy;
          yMax = tool.point1.dy;
        }

        for (int i in contraption.nodes.keys){
          var node = contraption.nodes[i];
          if ((xMin < node[0]) && (node[0] < xMax) && 
              (yMin < node[1]) && (node[1] < yMax)){
              selection.select(i);
          }
        }

        tool.point1 = null;
        tool.point2 = null;
      }

      break;
    }
    case 'Paste': {
      contraption.paste(tool.clipboard, position);
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
          BuildTools(),
          BuildComponents()
        ]
      )
    );
  }
}

class DoubleInput extends StatefulWidget{
  final String fieldName;
  final double minValue;
  final double shownValue;
  final double maxValue;
  final updateFunction;
  
  const DoubleInput({Key key, this.fieldName, this.minValue, this.shownValue, this.maxValue, this.updateFunction}): super(key: key);

  @override
  _DoubleInputState createState() => _DoubleInputState();
}

class _DoubleInputState extends State<DoubleInput>{
  String numValidator(String input){
    if (input == null){
      return widget.shownValue.toString();
    }

    double x = double.tryParse(input);
    if (x == null){
      return widget.shownValue.toString();
    }

    if (x < widget.minValue){
      x = widget.minValue;
    } else if (x > widget.maxValue){
      x = widget.maxValue;
    }

    String value = x.toString();

    return value;
  }

  @override
  Widget build(BuildContext context){
    return(
      Row(children: <Widget>[
        Container(child:
          TextField(
            decoration: InputDecoration(
              labelText: widget.fieldName,
            ),
            keyboardType: TextInputType.number, 
            textAlign: TextAlign.right,
            onChanged: (String input) => widget.updateFunction(double.parse(numValidator(input)))
          ),
          width: 150),
        Text(widget.shownValue.toString())
      ]) 
    );
  }
}

class IntInput extends StatefulWidget{
  final String fieldName;
  final int minValue;
  final int shownValue;
  final int maxValue;
  final updateFunction;
  
  const IntInput({Key key, this.fieldName, this.minValue, this.shownValue, this.maxValue, this.updateFunction}): super(key: key);

  @override
  _IntInputState createState() => _IntInputState();
}

class _IntInputState extends State<IntInput>{
String numValidator(String input){
    if (input == null){
      return widget.shownValue.toString();
    }

    int x = int.tryParse(input);
    if (x == null){
      return widget.shownValue.toString();
    }

    if (x < widget.minValue){
      x = widget.minValue;
    } else if (x > widget.maxValue){
      x = widget.maxValue;
    }

    String value = x.toString();

    return value;
  }

  @override
  Widget build(BuildContext context){
    return(
      Row(children: <Widget>[
        Container(child:
          TextField(
            decoration: InputDecoration(
              labelText: widget.fieldName,
            ),
            keyboardType: TextInputType.number, 
            textAlign: TextAlign.right,
            onChanged: (String input) => widget.updateFunction(int.parse(numValidator(input)))
          ),
          width: 150),
        Text(widget.shownValue.toString())
      ]) 
    );
  }
}

// TODO: add better displayed values
// TODO: change to dedicated tab interface
class BuildProperties extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var contraptionParameters = Provider.of<ContraptionParameters>(context);
    var environment = Provider.of<Environment>(context);
    var selection =  Provider.of<Selection>(context);

    return(
      Column(children: <Widget>[
        DoubleInput(
          fieldName: 'Mass', 
          minValue: 0.01,
          shownValue: contraptionParameters.defaultMass,
          maxValue: 100.0,
          updateFunction: (newMass) => contraptionParameters.editMass(selection.selectedNodes, newMass)
        ),
        DoubleInput(
          fieldName: 'Spring Strength', 
          minValue: 0.0,
          shownValue: contraptionParameters.defaultStrength,
          maxValue: 100.0,
          updateFunction: (newStrength) => contraptionParameters.editStrength(selection.selectedNodes, newStrength)
        ),
        DoubleInput(
          fieldName: 'Rest Length', 
          minValue: 0.01,
          shownValue: 1.0,
          maxValue: 100.0,
          updateFunction: (scale) => contraptionParameters.editRestLength(selection.selectedNodes, scale)
        ),
        DoubleInput(
          fieldName: 'Gravity', 
          minValue: -100.0,
          shownValue: environment.gravity,
          maxValue: 100.0,
          updateFunction: (newGravity) => environment.setGravity(newGravity)
        ),
        DoubleInput(
          fieldName: 'Elasticity', 
          minValue: 0.0,
          shownValue: environment.elasticity, 
          maxValue: 1.0,
          updateFunction: (newElasticity) => environment.setElasticity(newElasticity)
        ),
        DoubleInput(
          fieldName: 'Drag', 
          minValue: 0.0,
          shownValue: environment.drag,
          maxValue: 1.0,
          updateFunction: (newDrag) => environment.setDrag(newDrag)
        )
      ])
    );
  }
}

// TODO: add align and distribute functionality
// TODO: add scaling functionality to transform
class BuildTools extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Tool tool = Provider.of<Tool>(context, listen: false);
    Selection selection = Provider.of<Selection>(context, listen: false);
    ContraptionParameters parameters = Provider.of<ContraptionParameters>(context, listen: false);

    return(
      Column(children: <Widget>[
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.near_me),
            tooltip: 'Select',
            onPressed: () => tool.changeTool('Select'),
          ),
          IconButton(                
            icon: const Icon(Icons.select_all),
            tooltip: 'Select All',
            onPressed: () => selection.selectAll(parameters),
          ),
          IconButton(                
            icon: const Icon(Icons.crop_free),
            tooltip: 'Select in Region',
            onPressed: () => tool.changeTool('SelectRegion'),
          ),
          IconButton(                
            icon: const Icon(Icons.close),
            tooltip: 'Clear Selection',
            onPressed: () => selection.clearSelection(),
          ),
        ]),
        Row(children: <Widget>[
          IconButton(
            icon: const Icon(Icons.rotate_left),
            tooltip: 'Rotate Counterclockwise',
            onPressed: () => parameters.rotate(-3.14159/6.0, selection.selectedNodes)
          ),
          IconButton(
            icon: const Icon(Icons.rotate_right),
            tooltip: 'Rotate Clockwise',
            onPressed: () => parameters.rotate(3.14159/6.0, selection.selectedNodes)
          ),
          IconButton(
            icon: const Icon(Icons.flip),
            tooltip: 'Mirror Horizontally',
            onPressed: () => parameters.mirror(selection.selectedNodes, 'horizontal')
          ),
          IconButton(
            icon: Transform.rotate(angle: 3.14159/2, child:const Icon(Icons.flip)),
            tooltip: 'Mirror Vertically',
            onPressed: () => parameters.mirror(selection.selectedNodes, 'vertical')
          ),
        ]),
        Row(children: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Connect',
            onPressed: () => parameters.connect(selection.selectedNodes)
          ),
          IconButton(
            icon: const Icon(Icons.scatter_plot),
            tooltip: 'Disconnect',
            onPressed: () => parameters.disconnect(selection.selectedNodes)
          ),
          IconButton(
            icon: const Icon(Icons.transform),
            tooltip: 'Transform',
            onPressed: () => tool.changeTool('Transform')
          ),
        ]),
        Row(children: <Widget>[
          IconButton(                
            icon: const Icon(Icons.content_copy),
            tooltip: 'Copy',
            onPressed: () => tool.copy(selection.selectedNodes, parameters)
          ),
          IconButton(                
            icon: const Icon(Icons.content_paste),
            tooltip: 'Paste',
            onPressed: () => tool.changeTool('Paste')
          ),
          IconButton(                
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: (){
              parameters.delete(selection.selectedNodes);
              selection.clearSelection();
            }
          ),
        ]),
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
      ])
    );
  }
}

class RegularPolygon extends StatelessWidget{
  @override
  Widget build(BuildContext context){
      var tool = Provider.of<Tool>(context, listen: true);

      return Column(children: <Widget>[
        RaisedButton(
          onPressed: () => tool.changeTool('RegularPolygon'),
          child: Text('Regular Polygon')
        ),
        IntInput(
          fieldName: 'Polygon Points',
          minValue: 0,
          shownValue: tool.nPolygon,
          maxValue: 100,
          updateFunction: (input) => tool.nPolygonUpdate(input)
        ),
        DoubleInput(
          fieldName: 'Polygon Radius',
          minValue: 10.0,
          shownValue: tool.radiusPolygon,
          maxValue: 200.0,
          updateFunction: (input) => tool.radiusPolygonUpdate(input)
        ),
        // TODO: display connectivity value
       IntInput(
          fieldName: 'Polygon Connectivity',
          minValue: 1,
          shownValue: 0,
          maxValue: tool.nPolygon - 1,
          updateFunction: (input) => tool.connectivityPolygonUpdate(input)
        )
      ]);
  }
}
// Convert to tools with icons
class BuildComponents extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var tool = Provider.of<Tool>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        RaisedButton(
          onPressed: () => tool.changeTool('Node'),
          child: Text('Node')
        ),
        RaisedButton(
          onPressed: () => tool.changeTool('Spring'),
          child: Text('Spring')
        ),
        RegularPolygon()
      ],
    );
  }
}

// DISPLAY
class BuildDisplay extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var contraption = Provider.of<ContraptionParameters>(context, listen: false);
    var selection = Provider.of<Selection>(context, listen: false);
    var tool = Provider.of<Tool>(context, listen: true);

    return PositionedTapDetector(
      onTap: (position) => buildGesture(contraption, position.relative, tool, selection),
        child: CustomPaint(
          painter: BuildPainter(contraption, selection),
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
            ),
            child: Align(
              child: tool.toolIcon(tool.selectedTool),
              alignment: Alignment.bottomRight,
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
    var pointPaint = Paint();
    var selectPaint = Paint();
    selectPaint..style = PaintingStyle.stroke;

    var linePaint = Paint();

    var selected = selection.selectedNodes;

    for (int i in contraptionParameters.nodes.keys){
      var point = contraptionParameters.nodes[i];
      var radius = contraptionParameters.radius[i];
      
      if (selected.contains(i)) {
        canvas.drawCircle(Offset(point[0], point[1]), radius, selectPaint);
      } else {
        canvas.drawCircle(Offset(point[0], point[1]), radius, pointPaint);
      }
    }

    for (var line in contraptionParameters.connections){
      int i = line[0];
      int j = line[1];
      double x0 = contraptionParameters.nodes[i][0];
      double y0 = contraptionParameters.nodes[i][1];

      double x1 =  contraptionParameters.nodes[j][0];
      double y1 = contraptionParameters.nodes[j][1];

      print(contraptionParameters.springWidth);
      print(contraptionParameters.springWidth[SpringIndex(i,j)]);
      linePaint.strokeWidth = contraptionParameters.springWidth[SpringIndex(i,j)];

      double compressionRatio = contraptionParameters.dist(i, j) / 
                                contraptionParameters.restLength[SpringIndex(i,j)];
      
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
  bool shouldRepaint(BuildPainter oldDelegate) => true;
}