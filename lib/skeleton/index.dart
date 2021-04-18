import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum supported_platform {
  availablePublic,
  all,
  mobile,
  desktop,
  android,
  linux,
  windows,
  all_not_apple,
  all_apple,
  ios,
  ipados,
  macos
}

/*
* IndexVoice contains the standard elements to build route's part of App
* [labelRoute] and [labelName] would be used to build [route] and [title].
* */
class IndexVoiceBLOC {
  // fixed element
  final String labelRoute, labelName;
  final Widget builder;

  // public attribute
  Function onTap, onLongPress;

  // menu selector
  Map<supported_platform, bool> menuFilter = () {
    return {
      supported_platform.availablePublic: true,
      supported_platform.all: true,
      supported_platform.android: true,
      supported_platform.ios: true,
      supported_platform.ipados: true,
      supported_platform.macos: true,
      supported_platform.windows: true,
    };
  }();

  IndexVoiceBLOC(this.labelRoute, this.labelName, this.builder,
      {onTap, onLongPress, menuFilter});

  //TODO i18n
  String get title => this.labelName;

  // TODO i18n
  String get route => this.labelRoute;

  // get bool-map
  bool get available_drawer => menuFilter[supported_platform.all] && menuFilter[supported_platform.availablePublic];

  bool get available_drawer_mobile =>
      menuFilter[supported_platform.ios] ||
      menuFilter[supported_platform.android];

  bool get available_drawer_mobile_android =>
      menuFilter[supported_platform.android];

  bool get available_drawer_mobile_apple =>
      menuFilter[supported_platform.ios] ||
      menuFilter[supported_platform.ipados];

  bool get available_drawer_desktop =>
      menuFilter[supported_platform.linux] ||
      menuFilter[supported_platform.macos] ||
      menuFilter[supported_platform.android];

  bool get available_drawer_desktop_linux =>
      menuFilter[supported_platform.linux];

  bool get available_drawer_desktop_apple =>
      menuFilter[supported_platform.macos];

  bool get available_drawer_desktop_windows =>
      menuFilter[supported_platform.windows];

  set available_android(bool value) {
    menuFilter[supported_platform.android] = value;
  }

  set available_apple(bool value) {
    menuFilter[supported_platform.ios] = value;
    menuFilter[supported_platform.ipados] = value;
    menuFilter[supported_platform.macos] = value;
  }

  initMenuVoice(BuildContext context,
      {Function onTap, bool force: false, Object arguments}) {
    if ((onTap == null && this.onTap == null) || (force))
      this.onTap = () {
        // TODO verify if arguments still a good idea
        Navigator.popAndPushNamed(context, this.route, arguments: arguments);
      };
  }

  bool filter_by_platform(supported_platform platform) =>
      menuFilter.containsKey(platform) ? menuFilter[platform] : false;

  void setInternalLink(){
    menuFilter[supported_platform.availablePublic]= false;
  }
  void setGlobalLink(){
    menuFilter[supported_platform.availablePublic]= true;
  }
}

/*
* Simple class to manage all route
* */
class BuildIndex {
  BuildContext context;
  Map<String, IndexVoiceBLOC> treeVoices = Map<String, IndexVoiceBLOC>();

  BuildIndex({this.context});

  /**
   * Add only voices aren't already available/added to treeVoices
   */
  set addVoice(IndexVoiceBLOC candidate) {
    treeVoices.putIfAbsent(candidate.route, () => candidate);
  }

  Map<String, WidgetBuilder> init(
      {BuildContext context: null,
      supported_platform platform: supported_platform.all}) {
    if (context != null) this.context = context;
    Map<String, WidgetBuilder> buffer = Map<String, WidgetBuilder>();
    treeVoices.entries
        .toList()
        .where((element) => element.value.filter_by_platform(platform))
        .forEach((element) {
      buffer.putIfAbsent(
          element.key, () => (BuildContext context) => element.value.builder);
    });
    return buffer;
  }

  Map<String, IndexVoiceBLOC> filter_by_platform(
      {platform: supported_platform.all, BuildContext context: null}) {
    if (context != null) this.context = context;
    return Map.fromEntries(treeVoices.entries.toList().where(
        (MapEntry<String, IndexVoiceBLOC> element) =>
            element.value.filter_by_platform(platform)));
  }
}
