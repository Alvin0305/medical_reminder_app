import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../assets/MyTextField.dart';

class LoginPage extends StatelessWidget {
  LoginPage({
    super.key
  });
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double topHeight = screenHeight / 3;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(100, 173, 216, 230), Colors.white, Color.fromARGB(100, 255, 182, 193)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: topHeight,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.pinkAccent,
                          size: 55,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: screenHeight - topHeight,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Let's Sign You in",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome back, You've been missed",
                          style: TextStyle(
                            fontFamily: 'Lobster',
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Mytextfield(
                        label: "Type your Name",
                        controller: nameController,
                      ),
                      const SizedBox(height: 20),
                      Mytextfield(
                        label: "Type your Age",
                        controller: ageController,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                            shadowColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        onPressed: () {
                          String name = nameController.text;
                          int? age = int.tryParse(ageController.text);
                          if (name.isNotEmpty && ageController.text.isNotEmpty) {
                            Hive.box('userBox').put("name", name);
                            Hive.box('userBox').put("age", age);
                            Hive.box('userBox').put('logged_in', true);
                            Navigator.pushNamed(context, "/base");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Enter valid details"),
                                )
                            );
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}