import 'package:flutter/material.dart';

// TAB
class LearnTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[LearnInterface(), LearnDisplay()],
      )
    );
  }
}
// INTERFACE
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

// DISPLAY
class LearnDisplay extends StatelessWidget{
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
