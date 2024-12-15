import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/assets/HomePageTile.dart';
import 'package:medical_app/assets/Medicine.dart';
import 'package:medical_app/pages/add_reminder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedOption = "Daily";
  DateTime now = DateTime.now();

  String getWeekDay() {
    int weekday = now.weekday;
    String day;
    switch(weekday) {
      case 1:
        day = "Mon";
        break;
      case 2:
        day = "Tue";
        break;
      case 3:
        day = "Wed";
        break;
      case 4:
        day = "Thu";
        break;
      case 5:
        day = "Fri";
        break;
      case 6:
        day = "Sat";
        break;
      case 7:
        day = "Sun";
        break;
      default:
        day = "Invalid Data";
        break;
    }
    return day;
  }

  List<Medicine> dailyMedicines = Hive.box('userBox').get('dailyMedicines', defaultValue: <Medicine>[]);
  List<Medicine> weeklyMedicines = Hive.box('userBox').get('weeklyMedicines', defaultValue: <Medicine>[]);
  List<Medicine> monthlyMedicines = Hive.box('userBox').get('monthlyMedicines', defaultValue: <Medicine>[]);

  void addMedicine(Medicine medicine) {
    setState(() {
      if (medicine.frequency == 'Daily') {
        dailyMedicines.add(medicine);
        Hive.box('userBox').put('daily_medicines', dailyMedicines);
      } else if (medicine.frequency == 'Weekly') {
        weeklyMedicines.add(medicine);
        Hive.box('userBox').put('weekly_medicines', weeklyMedicines);
      } else {
        monthlyMedicines.add(medicine);
        Hive.box('userBox').put('monthly_medicines', monthlyMedicines);
      }
    });
  }

  void createMedicinesList() {
    Box user = Hive.box("userBox");
    dailyMedicines = (user.get("daily_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
    weeklyMedicines = (user.get("weekly_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
    monthlyMedicines = (user.get("monthly_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
  }


  List<Medicine> getMedicineList() {
    if (selectedOption == "Daily") {
      return dailyMedicines;
    } else if (selectedOption == "Weekly") {
      return weeklyMedicines;
    } else {
      return monthlyMedicines;
    }
  }

  void deleteItem(int index) {
    setState(() {
      if (selectedOption == 'Daily') {
        dailyMedicines.removeAt(index);
        Hive.box('userBox').put('daily_medicines', dailyMedicines);
      } else if (selectedOption == 'Weekly') {
        weeklyMedicines.removeAt(index);
        Hive.box('userBox').put('weekly_medicines', weeklyMedicines);
      } else {
        monthlyMedicines.removeAt(index);
        Hive.box('userBox').put('monthly_medicines', monthlyMedicines);
      }
    });
  }

  void editItem(int index, Medicine element) {
    deleteItem(index);
    setState(() {
      if (element.frequency == 'Daily') {
        dailyMedicines.add(element);
        Hive.box('userBox').put('daily_medicines', dailyMedicines);
      } else if (element.frequency == 'Weekly') {
        weeklyMedicines.add(element);
        Hive.box('userBox').put('weekly_medicines', weeklyMedicines);
      } else {
        monthlyMedicines.add(element);
        Hive.box('userBox').put('monthly_medicines', monthlyMedicines);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    createMedicinesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          createTopPart(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: getMedicineList().length,
                itemBuilder: (context, index) {
                  return Homepagetile(
                    type: getMedicineList()[index].type,
                    name: getMedicineList()[index].name,
                    times: getMedicineList()[index].times,
                    icon: getMedicineList()[index].icon,
                    onDelete: () => deleteItem(index),
                    medicine: getMedicineList()[index],
                    onUpdate: (updatedMedicine) => editItem(index, updatedMedicine),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        shape: const CircleBorder(
          eccentricity: 0,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicinePage()),
          );
          if (result != null) {
            addMedicine(result as Medicine);
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  List<String> createDayList() {
    List<String> list = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    String day = getWeekDay();
    List<String> output = [];
    int i = list.indexOf(day);
    for (int j = i; j < list.length; j++) {
      output.add(list[j]);
    }
    for (int j = 0; j < i; j++) {
      output.add(list[j]);
    }
    return output;
  }

  Row createDates() {
  List<String> days = createDayList();
  DateTime now = DateTime.now(); 

  return Row(
    children: [
      for (int i = 0; i < days.length; i++)
        Expanded(
          child: Column(
            children: [
              Text(
                days[i],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                now.add(Duration(days: i)).day.toString(), 
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
    ],
  );
}


  Container createTopPart() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          // bottomRight: Radius.circular(20),
        ),
        gradient: LinearGradient(
          colors: [Color.fromARGB(100, 173, 216, 230), Colors.white, Color.fromARGB(100, 255, 182, 193)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Your Medicines\nRemainder",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          getWeekDay(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          now.day.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.zero,
              child: createDates(),
            ),
            const SizedBox(height: 15),
            createButtons(),
          ],
        ),
      ),
    );
  }

  Row createButtons() {
    List<String> list = ["Daily", "Weekly", "Monthly"];
    return Row(
      children: [
        for (String option in list)
          Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.transparent),
                    )
                ),
                onPressed: () {
                  setState(() {
                    selectedOption = option;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      option,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 20,
                      ),
                    ),
                    if (selectedOption == option)
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 2,
                        width: 50,
                        color: Colors.black45,
                      )
                  ],
                ),
              )
          )
      ],
    );
  }
}