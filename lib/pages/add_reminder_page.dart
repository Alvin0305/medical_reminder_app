import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/assets/AddReminderHeading.dart';
import 'package:medical_app/assets/MedicineTypeTile.dart';
import 'package:medical_app/assets/MyButton.dart';
import 'package:medical_app/assets/ScheduleTile.dart';
import 'package:medical_app/services/notification_service.dart';

import '../assets/MyTextField.dart';
import '../assets/Medicine.dart';

class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({
    super.key,
  });

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {

  final Box hiveBox = Hive.box('userBox');

  String _timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute}';
  }

  TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  TimeOfDay _getStoredTime(String key, TimeOfDay defaultValue) {
    final storedValue = hiveBox.get(key);
    if (storedValue != null) {
      return _stringToTimeOfDay(storedValue.toString());
    } else {
      return defaultValue;
    }
  } 

  String _getTime(String key) {
    if (hiveBox.get(key) != null) {
      return hiveBox.get(key);
    } else if (key == 'before_breakfast') {
      return '7:0';
    } else if (key == 'after_breakfast') {
      return '9:0';
    } else if (key == 'before_lunch') {
      return '12:0';
    } else if (key == 'after_lunch') {
      return '14:0';
    } else if (key == 'before_dinner') {
      return '18:0';
    } else if (key == 'after_dinner') {
      return '20:0';
    } else {
      return '19:30';
    }
  }

  TextEditingController nameController = TextEditingController();
  List<bool> selectedType = [true, false, false];
  String selectedTypeValue = 'syrup';
  List<String> types = ['syrup', 'tablet', 'syringe'];
  List<String> schedules = [];
  List<String> timings = [
    'before breakfast', 'after breakfast', 'before lunch', 'after lunch', 'before dinner', 'after dinner'
  ];
  List<bool> selectedTimings = [
    false, false, false, false, false, false
  ];
  List<String> selectedTimes = [];
  int duration = 1;
  String durationValue = '1 Month';
  String frequencyValue = 'Daily';
  bool isLifeTime = false;
  int years = 0;
  int months = 0;
  int weeks = 0;
  List<String> availableFrequencies = [
    'Daily', 'Weekly', 'Monthly'
  ];
  int frequencyIndex = 0;
  int frequencyLength = 3;

  Widget _buildInputRow(String label, int initialValue, Function(String) onChanged) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: initialValue.toString(),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.pinkAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "New Reminder",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(
                  FontAwesomeIcons.notesMedical,
                  color: Colors.pinkAccent,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Addreminderheading(text: 'Medicine Name'),
                const SizedBox(height: 10),
                Mytextfield(label: 'Enter Medicine Name', controller: nameController),
                const SizedBox(height: 20),
                const Addreminderheading(text: 'Type'),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  child: ToggleButtons(
                    isSelected: selectedType,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < selectedType.length; i++) {
                          selectedType[i] = i == index;
                        }
                        selectedTypeValue = types[index];
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.deepPurpleAccent,
                    fillColor: Colors.white,
                    color: Colors.black87,
                    borderColor: Colors.grey,
                    selectedBorderColor: Colors.pinkAccent,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Medicinetypetile(icon: FontAwesomeIcons.prescriptionBottle),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Medicinetypetile(icon: FontAwesomeIcons.pills),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Medicinetypetile(icon: FontAwesomeIcons.syringe),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Addreminderheading(text: 'Time & Schedule'),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(
                                eccentricity: 0,
                              ),
                              backgroundColor: Colors.pinkAccent
                          ),
                          onPressed: () async {
                            List<String>? result = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Select the Timings',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pinkAccent,
                                        ),
                                      ),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Choose one or more timings:",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              // A more compact ListView with reduced vertical spacing
                                              ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: timings.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.only(bottom: 8.0),
                                                    child: CheckboxListTile(
                                                      activeColor: Colors.pinkAccent,
                                                      controlAffinity: ListTileControlAffinity.leading,
                                                      title: Text(
                                                        timings[index],
                                                        style: const TextStyle(fontSize: 16),
                                                      ),
                                                      value: selectedTimings[index],
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          selectedTimings[index] = value!;
                                                        });
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: TextButton.styleFrom(foregroundColor: Colors.grey),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            List<String> selectedTimingValues = [];
                                            for (int i = 0; i < timings.length; i++) {
                                              if (selectedTimings[i]) {
                                                selectedTimingValues.add(timings[i]);
                                              }
                                            }
                                            Navigator.pop(context, selectedTimingValues);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.pinkAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    );
                                  },
                                );
                              },
                            );

                            // Process the result
                            if (result != null) {
                              setState(() {
                                selectedTimes = [];
                                for (int i = 0; i < selectedTimings.length; i++) {
                                  if (selectedTimings[i]) {
                                    selectedTimes.add(timings[i]);
                                  }
                                }
                              });
                            }
                          },


                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )
                      ),
                      for (int i = 0; i < selectedTimes.length; i++)
                        Scheduletile(text: selectedTimes[i])
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                          children: [
                            const Addreminderheading(text: 'Duration'),
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 230, 230, 255),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 230, 230, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      bool localIsLifeTime = isLifeTime;
                                      int localYears = years;
                                      int localMonths = months;
                                      int localWeeks = weeks;

                                      return AlertDialog(
                                        title: const Text(
                                          'Select Duration',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pinkAccent,
                                          ),
                                        ),
                                        content: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setDialogState) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    // Lifetime Checkbox
                                                    CheckboxListTile(
                                                      activeColor: Colors.pinkAccent,
                                                      title: const Text(
                                                        "Lifetime",
                                                        style: TextStyle(fontSize: 16),
                                                      ),
                                                      value: localIsLifeTime,
                                                      onChanged: (value) {
                                                        setDialogState(() {
                                                          localIsLifeTime = value!;
                                                          if (localIsLifeTime) {
                                                            localYears = 0;
                                                            localMonths = 0;
                                                            localWeeks = 0;
                                                          }
                                                        });
                                                      },
                                                    ),

                                                    // Custom Duration Input Fields
                                                    if (!localIsLifeTime)
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          _buildInputRow(
                                                            "Years",
                                                            localYears,
                                                            (value) => setDialogState(() {
                                                              localYears = int.tryParse(value) ?? 0;
                                                            }),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          _buildInputRow(
                                                            "Months",
                                                            localMonths,
                                                            (value) => setDialogState(() {
                                                              localMonths = int.tryParse(value) ?? 0;
                                                            }),
                                                          ),
                                                          const SizedBox(height: 10),
                                                          _buildInputRow(
                                                            "Weeks",
                                                            localWeeks,
                                                            (value) => setDialogState(() {
                                                              localWeeks = int.tryParse(value) ?? 0;
                                                            }),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: TextButton.styleFrom(foregroundColor: Colors.grey),
                                            child: const Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                isLifeTime = localIsLifeTime;
                                                years = localYears;
                                                months = localMonths;
                                                weeks = localWeeks;
                                                durationValue = isLifeTime ? 'lifetime' : 'custom';
                                              });
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.pinkAccent,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: ListTile(
                                  leading: const Icon(Icons.calendar_month),
                                  title: Text(durationValue),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            const Addreminderheading(text: 'Frequency'),
                            Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(255, 230, 230, 255),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                    )
                                ),
                                onPressed: () {
                                  setState(() {
                                    frequencyIndex = (frequencyIndex + 1) % frequencyLength;
                                    frequencyValue = availableFrequencies[frequencyIndex];
                                  });
                                },
                                child: ListTile(
                                  leading: const Icon(Icons.timer),
                                  title: Text(frequencyValue),
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Mybutton(
                    onPressed: () {
                      for (String time in selectedTimes) {
                        TimeOfDay timeOfDay = _stringToTimeOfDay(_getTime(time.replaceAll(' ', '_')));
                        print(timeOfDay);
                        NotificationService().scheduleNotification(
                          title: 'Take Your Medicine', 
                          body: nameController.text, 
                          hour: timeOfDay.hour, 
                          minute: timeOfDay.minute
                        );
                      }
                      String name = nameController.text;
                      if (name.isNotEmpty) {
                        Medicine medicine = Medicine(
                            name: name,
                            type: selectedTypeValue,
                            times: selectedTimes,
                            duration: isLifeTime ? [1000] : [years, months, weeks],
                            frequency: frequencyValue,
                            mark: false
                        );
                        Navigator.pop(context, medicine);
                      }
                    },
                    text: 'Add Remainder'
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}