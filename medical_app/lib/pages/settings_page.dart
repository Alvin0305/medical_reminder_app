import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Box hiveBox = Hive.box('userBox');

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  late Map<String, TimeOfDay> selectedTimes;

  TimeOfDay _getStoredTime(String key, TimeOfDay defaultValue) {
    final storedValue = hiveBox.get(key);
    if (storedValue != null) {
      return _stringToTimeOfDay(storedValue.toString());
    } else {
      return defaultValue;
    }
  } 

  @override
  void initState() {
    super.initState();

    selectedTimes = {
      'Before Breakfast': _getStoredTime('before_breakfast', const TimeOfDay(hour: 7, minute: 0)),
      'After Breakfast': _getStoredTime('after_breakfast', const TimeOfDay(hour: 9, minute: 0)),
      'Before Lunch': _getStoredTime('before_lunch', const TimeOfDay(hour: 12, minute: 0)),
      'After Lunch': _getStoredTime('after_lunch', const TimeOfDay(hour: 14, minute: 0)),
      'Before Dinner': _getStoredTime('before_dinner', const TimeOfDay(hour: 18, minute: 0)),
      'After Dinner': _getStoredTime('after_dinner', const TimeOfDay(hour: 20, minute: 0)),
    };
  }

  // Function to pick a time
  Future<void> _pickTime(String title) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimes[title] ?? const TimeOfDay(hour: 0, minute: 0),
    );
    if (pickedTime != null) {
      final key = title.toLowerCase().replaceAll(' ', '_');
      hiveBox.put(key, _timeOfDayToString(pickedTime));
      setState(() {
        selectedTimes[title] = pickedTime; // Update the selected time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.pinkAccent,
      elevation: 4,
      shadowColor: Colors.pink.shade100,
    ),
    backgroundColor: Colors.pink.shade50, 
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.pinkAccent.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Set Timings",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
              // Collapsible ListTile
              ExpansionTile(
                title: const Text(
                  "Set Time for Reminders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.pinkAccent,
                  ),
                ),
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.pinkAccent,
                ),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.purple.shade50.withOpacity(0.6),
                childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
                children: [
                  // Dynamically generate the options and text fields
                  ...selectedTimes.entries.map((entry) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Title for each option
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          // Time Display with Gesture
                          GestureDetector(
                            onTap: () => _pickTime(entry.key),
                            child: Container(
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.pinkAccent, width: 1.5),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Text(
                                entry.value.format(context), // Show picked time
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.pinkAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
