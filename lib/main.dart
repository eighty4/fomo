import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'map.dart';
import 'model.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: MapApp())));

class ActivityTabModel extends ChangeNotifier {
  ActivityType? openPane;

  setOpenActivityPane(ActivityType? openedPane) {
    openPane = openedPane;
    notifyListeners();
  }

  setNoOpenActivityPane() => setOpenActivityPane(null);
}

class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  MapAppState createState() => MapAppState();
}

class MapAppState extends State<MapApp> {
  ActivityType? openActivityPane;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ActivityTabModel(),
      child: Stack(
        children: const [
          Positioned(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: MapWrap(),
          ),
          ActivityTab(activityType: ActivityType.dining, bottomOffset: 160),
          ActivityTab(activityType: ActivityType.market, bottomOffset: 100),
          ActivityTab(activityType: ActivityType.music, bottomOffset: 40),
        ],
      ),
    );
  }
}

extension IconFn on ActivityType {
  IconData icon() {
    switch (this) {
      case ActivityType.music:
        return FontAwesomeIcons.music;
      case ActivityType.dining:
        return FontAwesomeIcons.utensils;
      case ActivityType.market:
        return FontAwesomeIcons.store;
      default:
        return FontAwesomeIcons.question;
    }
  }
}

class ActivityTab extends StatelessWidget {
  static const double buttonSize = 50;
  static const animationDuration = Duration(milliseconds: 500);

  final ActivityType activityType;
  final double bottomOffset;

  const ActivityTab(
      {super.key, required this.activityType, required this.bottomOffset});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final tabModel = context.watch<ActivityTabModel>();
    final isThisPaneOpen = tabModel.openPane == activityType;
    final isOtherPaneOpen = !isThisPaneOpen && tabModel.openPane != null;
    return AnimatedPositioned(
      top: isThisPaneOpen
          ? size.height / 2
          : size.height - ActivityTab.buttonSize - bottomOffset,
      left: !isOtherPaneOpen ? -1 : -1 - ActivityTab.buttonSize,
      bottom: isThisPaneOpen ? -1 : bottomOffset,
      right: isThisPaneOpen
          ? -1
          : !isOtherPaneOpen
              ? size.width - ActivityTab.buttonSize
              : size.width,
      duration: ActivityTab.animationDuration,
      curve: Curves.easeInOutExpo,
      child: GestureDetector(
        onTap: () {
          if (isThisPaneOpen) {
            tabModel.setNoOpenActivityPane();
          } else {
            tabModel.setOpenActivityPane(activityType);
          }
        },
        child: Container(
            decoration: const BoxDecoration(
                border: Border.fromBorderSide(BorderSide(color: Colors.orange)),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Colors.black87, Colors.black54])),
            constraints: const BoxConstraints.expand(),
            child: AnimatedSwitcher(
              duration: ActivityTab.animationDuration,
              child: isOtherPaneOpen
                  ? const SizedBox.expand()
                  : isThisPaneOpen
                      ? const ActivityPaneContent()
                      : FaIcon(
                          activityType.icon(),
                          color: Colors.blue,
                          size: 16,
                        ),
            )),
      ),
    );
  }
}

class ActivityPaneContent extends StatefulWidget {
  const ActivityPaneContent({super.key});

  @override
  ActivityPaneContentState createState() => ActivityPaneContentState();
}

class ActivityPaneContentState extends State<ActivityPaneContent> {
  final ScrollController _scrollController = ScrollController();

  List<Activity>? activities;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getActivities().then((activities) {
      if (mounted) {
        setState(() {
          this.activities = activities;
        });
      }
    });
  }

  void _onScroll() {
    if (kDebugMode) {
      print("maxScrollExtent ${_scrollController.position.extentBefore}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => context.read<ActivityTabModel>().setNoOpenActivityPane(),
      child: Container(
          constraints: const BoxConstraints.expand(),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            switchInCurve: Curves.linear,
            switchOutCurve: Curves.easeInExpo,
            child: activities == null
                ? const CircularProgressIndicator()
                : ListView(
                    controller: _scrollController,
                    children: activities!
                        .map((activity) => ActivityWidget(activity))
                        .toList(),
                  ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}

class ActivityWidget extends StatelessWidget {
  final Activity activity;

  const ActivityWidget(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB3E5FC),
      padding: const EdgeInsets.symmetric(vertical: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text(
            activity.title,
            textScaleFactor: 2,
          ),
        ],
      ),
    );
  }
}
