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
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.edit)),
                Tab(icon: Icon(Icons.nature)),
                Tab(icon: Icon(Icons.lightbulb_outline)),
              ],
            ),
            title: Text('Reinforced Springs'),
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
      Center(
        child: Text(
          'Create a contraption here.'
        ),
      )
    );
  }
}

class PlayTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Center(
        child: Text(
          'Play with your contraption here.'
        ),
      )
    );
  }
}

class LearnTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(
      Center(
        child: Text(
          'Teach your contraption here.'
        ),
      )
    );
  }
}
