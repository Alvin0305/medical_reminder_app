import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

part 'Medicine.g.dart';

@HiveType(typeId: 0)
class Medicine {

  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  List<String> times;

  @HiveField(3)
  List<int> duration;

  @HiveField(4)
  String frequency;

  @HiveField(5)
  bool mark;

  late Icon icon;

  Medicine({
    required this.name,
    required this.type,
    required this.times,
    required this.duration,
    required this.frequency,
    required this.mark,
  }) {
    if (type == "tablet") {
      icon = const Icon(
        FontAwesomeIcons.pills,
        color: Colors.deepPurpleAccent,
      );
    } else if (type == "syrup") {
      icon = const Icon(
        FontAwesomeIcons.prescriptionBottle,
        color: Colors.deepPurpleAccent,
      );
    } else {
      icon = const Icon(
        FontAwesomeIcons.syringe,
        color: Colors.deepPurpleAccent,
      );
    }
  }

  String getName() {
    return name;
  }

  String getType() {
    return type;
  }

  List<String> getTimes() {
    return times;
  }

  Icon getIcon() {
    return icon;
  }

}