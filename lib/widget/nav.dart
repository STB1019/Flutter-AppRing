import 'package:appring/skeleton/base.dart';
import 'package:appring/skeleton/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuilderNavWidget extends StatefulWidget {
  @override
  StartStateBuilderNav createState() {
    return StartStateBuilderNav();
  }
}

class StartStateBuilderNav extends State<BuilderNavWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          itemCount: BaseRoute(context).drawer_voices_as_list.length,
          itemBuilder: (BuildContext context, int index) {
            return IndexVoiceWidgetListTile(
                BaseRoute(context).drawer_voices_as_list[index]);
          }),
    );
  }
}

/*
* This is the real widget used to show data in ListTile form
* */
class IndexVoiceWidgetListTile extends StatelessWidget {
  final IndexVoiceBLOC voice;

  IndexVoiceWidgetListTile(this.voice);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(voice.title),
        onTap: () {
          // TODO add screenArguments
          Navigator.popAndPushNamed(context, voice.route);
        });
  }
}
