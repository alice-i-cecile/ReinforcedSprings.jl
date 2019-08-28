import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;


import 'contraption.dart';
import 'build.dart';
import 'play.dart';
import 'learn.dart';

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