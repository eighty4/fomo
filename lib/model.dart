import 'dart:math';

import 'package:flutter/foundation.dart';

/// Stub data
Future<List<Activity>> getActivities() async {
  if (kDebugMode) print("getActivities");
  await Future.delayed(Duration(milliseconds: 100 + Random().nextInt(900)));
  return [
    Activity("Cleaning", Location(0, 0), Scheduling(weekly: Day.fri)),
    Activity("Running", Location(0, 0), Scheduling(weekly: Day.fri)),
    Activity("Gaming", Location(0, 0), Scheduling(weekly: Day.fri)),
    Activity("Erging", Location(0, 0), Scheduling(weekly: Day.fri)),
  ];
}

enum ActivityType { one, two, three }

extension LabelFn on ActivityType {
  String label() {
    switch (this) {
      case ActivityType.one:
        return "1";
      case ActivityType.two:
        return "2";
      case ActivityType.three:
        return "3";
      default:
        return "?";
    }
  }
}

class Activity {
  final String title;
  final Location location;
  final Scheduling when;

  Activity(this.title, this.location, this.when);
}

class Location {
  final int lat;
  final int lon;

  Location(this.lat, this.lon);
}

class Scheduling {
  final Day? weekly;
  final int? monthly;
  final DateTime? explicitly;

  Scheduling({this.weekly, this.monthly, this.explicitly}) {
    assert(weekly != null || monthly != null || explicitly != null);
  }
}

enum Day { mon, tue, wed, thu, fri, sat, sun }
