import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
          ActivityTab(activityType: ActivityType.one, bottomOffset: 200),
          ActivityTab(activityType: ActivityType.two, bottomOffset: 125),
          ActivityTab(activityType: ActivityType.three, bottomOffset: 50),
        ],
      ),
    );
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
      left: !isOtherPaneOpen ? 0 : 0 - ActivityTab.buttonSize,
      bottom: isThisPaneOpen ? 0 : bottomOffset,
      right: isThisPaneOpen
          ? 0
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
            color: const Color(0x30FF4081),
            constraints: const BoxConstraints.expand(),
            child: AnimatedSwitcher(
              duration: ActivityTab.animationDuration,
              child: isOtherPaneOpen
                  ? const SizedBox.expand()
                  : isThisPaneOpen
                      ? const ActivityPaneContent()
                      : Text(activityType.label(),
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white)),
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
    return Container(
        color: const Color(0x30FF4081),
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
        ));
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
