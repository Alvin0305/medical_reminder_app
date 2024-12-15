import 'dart:core';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/assets/Medicine.dart';
import 'package:medical_app/assets/MyButton.dart';
import 'package:medical_app/assets/MyTextField.dart';
import 'package:medical_app/assets/ProfilePageTile.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Box box = Hive.box('userBox');
  List<Medicine> dailyMedicines = Hive.box('userBox').get('dailyMedicines', defaultValue: <Medicine>[]);
  List<Medicine> weeklyMedicines = Hive.box('userBox').get('weeklyMedicines', defaultValue: <Medicine>[]);
  List<Medicine> monthlyMedicines = Hive.box('userBox').get('monthlyMedicines', defaultValue: <Medicine>[]);
  String name = Hive.box('userBox').get('name');
  int age = Hive.box('userBox').get('age');

  List<Medicine> getMedicineList() {
    List<Medicine> output = <Medicine>[];
    output.addAll(dailyMedicines);
    output.addAll(weeklyMedicines);
    output.addAll(monthlyMedicines);
    return output;
  }

  void createMedicinesList() {
    Box user = Hive.box("userBox");
    dailyMedicines = (user.get("daily_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
    weeklyMedicines = (user.get("weekly_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
    monthlyMedicines = (user.get("monthly_medicines") as List?)?.cast<Medicine>() ?? <Medicine>[];
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
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20,),
              child: Text(
                'Ongoing Courses',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: getMedicineList().length,
                itemBuilder: (context, index) {
                  return Profilepagetile(medicine: getMedicineList()[index]);
                }
            ),
          ),
        ],
      ),
    );
  }

  Container createTopPart() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          // bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient: LinearGradient(
          colors: [Color.fromARGB(100, 255, 182, 193), Colors.white, Color.fromARGB(100, 173, 216, 230),],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: const Icon(
                Icons.person,
                size: 60,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Age: ${age.toString()}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Mybutton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController nameController = TextEditingController(text: name);
                    TextEditingController ageController = TextEditingController(text: age.toString());

                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Color.fromARGB(255, 233, 30, 99), // Pink accent color
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Mytextfield(
                              label: 'Enter your name',
                              controller: nameController,
                            ),
                            const SizedBox(height: 10),
                            Mytextfield(
                              label: 'Enter your age',
                              controller: ageController,
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.grey.shade300,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color.fromARGB(255, 233, 30, 99), // Pink accent color
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                String newName = nameController.text;
                                int? newAge = int.tryParse(ageController.text);
                                if (newName.isNotEmpty && newAge != null) {
                                  Hive.box('userBox').put('name', newName);
                                  Hive.box('userBox').put('age', newAge);
                                  setState(() {
                                    name = newName;
                                    age = newAge;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              text: 'Edit Profile',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}