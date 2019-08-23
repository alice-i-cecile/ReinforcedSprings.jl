import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(MaterialApp(home: ModeTabs()));
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
                tooltip: 'New Contraption'
              ),
              IconButton(
                icon: const Icon(Icons.folder_open),
                tooltip: 'Load Contraption'
              ),
              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'Save Contraption',
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                tooltip: 'Program Settings',
              ),
              IconButton(
                icon: const Icon(Icons.help),
                tooltip: 'Help',
              ),

            ], 
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit)),
                Tab(icon: Icon(Icons.toys)),
                Tab(icon: Icon(Icons.school)),
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
        children: <Widget>[BuildInterface(), Display()],
      )
    );
  }
}
class BuildInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Mass"), 
          Text("Spring Strength"),
          Text("Components"),
          Text("Control 4"),
          Text("Control 5"),
        ]
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


class PlayInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Gravity"), 
          Text("Elasticity"),
          Text("Environment"),
          Text("Control 4"),
          Text("Control 5"),
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
        // TODO: Dynamically inherit constraints from parent?
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        )
      )
    );
  }
}
