import 'package:provider/provider.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import 'package:flutter/material.dart';
import 'dart:math';

import 'contraption.dart';
import 'icons.dart';
import 'input.dart';

// STATE
// TODO: change selectedTool to enum
class Tool with ChangeNotifier{
  String selectedTool = 'Select';
  Offset point1;
  Offset point2;

  int nPolygon = 5;
  double radiusPolygon = 50.0;
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
        icon = Icon(ToolIcons.node);
        break;
      }
      case 'Spring': {
        icon = Icon(ToolIcons.spring);
        break;
      }
      case 'RegularPolygon': {
        icon = Icon(ToolIcons.regular_polygon);
        break;
      }
      case 'Select': {
        icon = Icon(Icons.near_me);
        break;
      }
      case 'SelectRegion': {
        icon = Icon(Icons.crop_square);
        break;
      }
      case 'Paste': {
        icon = Icon(Icons.content_paste);
        break;
      }
      case 'Translate': {
        icon = Icon(ToolIcons.translate);
        break;
      }
      case 'Scale': {
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

  switch(tool.selectedTool) {
    case 'Node': {
      contraption.node(position.dx, position.dy);
      break;
    }
    case 'Spring': {
      if (contraption.nodes.length >= 2){
        if (selection.selectedNodes.length != 1){
          selection.clearSelection();
          selection.select(contraption.nearest(position.dx, position.dy));
        } else {
          selection.select(contraption.nearest(position.dx, position.dy));
          if (selection.selectedNodes.length == 2){
            var node12 = selection.selectedNodes.toList();
            int node1 = node12[0];
            int node2 = node12[1];
            contraption.spring(node1, node2);
          }
        }
      }

      break;
    }
    case 'Select': {
      if (contraption.nodes.length >= 1){            
        selection.select(contraption.nearest(position.dx, position.dy));    
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

    case 'Translate': {
      contraption.translate(position, selection.selectedNodes);
      break;
    }

    case 'Scale': {
      if (tool.point1 == null){
        tool.point1 = position;
      } else {
        tool.point2 = position;
        contraption.scale(tool.point1, tool.point2, selection.selectedNodes);

        tool.point1 = null;
        tool.point2 = null;
      }
      break;
    }
  }

}

// TAB
class BuildTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Provider.of<Tool>(context, listen: false).changeTool('Node');
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

class EditTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          EditInterface(), 
          BuildDisplay()],
      )
    );
  }
}

// INTERFACE
// TODO: custom icons
// TODO: add grouping functionality
// TODO: add toy chest functionality
class BuildInterface extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    Tool tool = Provider.of<Tool>(context, listen: false);
    Selection selection = Provider.of<Selection>(context, listen: false);
    ContraptionParameters parameters = Provider.of<ContraptionParameters>(context, listen: false);

    return(
      Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children: <Widget>[
            IconButton(
              icon: Icon(ToolIcons.node),
              tooltip: 'Create Node',
              onPressed: () => tool.changeTool('Node'),
            ),
            IconButton(
              icon: Icon(ToolIcons.spring),
              tooltip: 'Create Spring',
              onPressed: () => tool.changeTool('Spring'),
            ),          
            IconButton(
              icon: Icon(ToolIcons.regular_polygon),
              tooltip: 'Create Regular Polygon',
              onPressed: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) => PolygonDialog(tool: tool)
                );
              },
            ),
            IconButton(
              icon: Icon(ToolIcons.toy_chest),
              tooltip: 'Toy Chest',
              onPressed: () => {},
            ),
          ]),
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
              icon: const Icon(Icons.crop_square),
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
              icon: Icon(Icons.group),
              tooltip: 'Groups',
              onPressed: () => {},
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
              icon: const Icon(Icons.translate),
              tooltip: 'Translate Nodes',
              onPressed: () => tool.changeTool('Translate')
            ),
            IconButton(
              icon: const Icon(Icons.transform),
              tooltip: 'Scale Nodes',
              onPressed: () => tool.changeTool('Scale')
            ),
          ],),
          Row(children: <Widget>[
            IconButton(
              icon: Icon(ToolIcons.align),
              tooltip: 'Align Vertically',
              onPressed: () => parameters.align(selection.selectedNodes, 'vertical'),
            ),
            IconButton(
              icon: Transform.rotate(angle: 3.14159/2, child:Icon(ToolIcons.align)),
              tooltip: 'Align Horizontally',
              onPressed: () => parameters.align(selection.selectedNodes, 'horizontal'),
            ),
            IconButton(
              icon: Icon(ToolIcons.distribute),
              tooltip: 'Distribute Vertically',
              onPressed: () => parameters.distribute(selection.selectedNodes, 'vertical'),
            ),
            IconButton(
              icon: Transform.rotate(angle: 3.14159/2, child:Icon(ToolIcons.distribute)),
              tooltip: 'Distribute Horizontally',
              onPressed: () => parameters.distribute(selection.selectedNodes, 'horizontal'),
            ),  
          ]),
        ]
      )
    );
  }
}

class PolygonDialog extends StatelessWidget{
  final Tool tool;

  PolygonDialog({
    @required this.tool,
  });

  @override
  Widget build(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        width: 150,
        height: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: PolygonForm(tool: tool)
      ) 
    );
  }
}

class PolygonForm extends StatefulWidget {
  final Tool tool;
  PolygonForm({
    @required this.tool
  });

  @override
  _PolygonFormState createState() => _PolygonFormState();
}

class _PolygonFormState extends State<PolygonForm>{

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Number of points'
            ),
            validator: (value) => rangeValidator(value, 0, 100),
            onSaved: (value) => widget.tool.nPolygon = num.parse(value).floor(),
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Polygon radius'
            ),
            validator: (value) => rangeValidator(value, 10, 200),
            onSaved: (value) => widget.tool.radiusPolygon = double.parse(value),
          ),
          // TODO: allow specification of set for polygon connectivity
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Polygon connections'
            ),
            validator: (value) => rangeValidator(value, 0, 100),
            onSaved: (value){
              Set<int> connectivity = Set();
              connectivity.add(num.parse(value).floor());
              widget.tool.connectivityPolygon = connectivity;
            },
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: (){
                  Navigator.of(context).pop();
                },),
              FlatButton(
                child: Text("Confirm"),
                onPressed: (){
                  final form = _formKey.currentState;
                  if (form.validate()){
                    form.save();                      
                    widget.tool.changeTool('RegularPolygon');
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          ),
        ],
      )
    );
  }
}

/*
if (_formKey.currentState.validate())
onPressed: (){
          tool.changeTool('RegularPolygon');
          Navigator.of(context).pop();
        }
*/
// EDIT INTERFACE
class EditInterface extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        EditProperties(),
        EditTools()
      ]
    );
  }
}


class EditProperties extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var contraptionParameters = Provider.of<ContraptionParameters>(context);
    var environment = Provider.of<Environment>(context);
    var selection =  Provider.of<Selection>(context);

    return(
      Column(children: <Widget>[
        NumInput(
          fieldName: 'Mass', 
          minValue: 0.01,
          shownValue: contraptionParameters.defaultMass,
          maxValue: 100.0,
          updateFunction: (newMass) => contraptionParameters.editMass(selection.selectedNodes, newMass)
        ),
        NumInput(
          fieldName: 'Spring Strength', 
          minValue: 0.0,
          shownValue: contraptionParameters.defaultStrength,
          maxValue: 100.0,
          updateFunction: (newStrength) => contraptionParameters.editStrength(selection.selectedNodes, newStrength)
        ),
        NumInput(
          fieldName: 'Rest Length', 
          minValue: 0.01,
          shownValue: 1.0,
          maxValue: 100.0,
          updateFunction: (scale) => contraptionParameters.editRestLength(selection.selectedNodes, scale)
        ),
        NumInput(
          fieldName: 'Gravity', 
          minValue: -100.0,
          shownValue: environment.gravity,
          maxValue: 100.0,
          updateFunction: (newGravity) => environment.setGravity(newGravity)
        ),
        NumInput(
          fieldName: 'Elasticity', 
          minValue: 0.0,
          shownValue: environment.elasticity, 
          maxValue: 1.0,
          updateFunction: (newElasticity) => environment.setElasticity(newElasticity)
        ),
        NumInput(
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

class EditTools extends StatelessWidget{

@override
Widget build(BuildContext context) {
    Tool tool = Provider.of<Tool>(context, listen: false);
    Selection selection = Provider.of<Selection>(context, listen: false);
    ContraptionParameters parameters = Provider.of<ContraptionParameters>(context, listen: false);
    
    return Row(children: <Widget>[
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
        icon: const Icon(Icons.crop_square),
        tooltip: 'Select in Region',
        onPressed: () => tool.changeTool('SelectRegion'),
      ),
      IconButton(                
        icon: const Icon(Icons.close),
        tooltip: 'Clear Selection',
        onPressed: () => selection.clearSelection(),
      ),
    ]);
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