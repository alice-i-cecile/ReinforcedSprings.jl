import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

main() {
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;

  runApp(MaterialApp(
    home: ChangeNotifierProvider(
      builder: (context) => Counter(),
      child: ModeTabs(),
    )
  ));
}

class Counter with ChangeNotifier {
  int value = 0;

  void increment() {
    value += 1;
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
        child: FlatButton(
          child: Consumer<Counter>(
            builder: (context, counter, child) => Text('${counter.value}')
          ),
          onPressed: () => Provider.of<Counter>(context, listen: false).increment()
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
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(width: 2),
        ),
      )
    );
  }
}
