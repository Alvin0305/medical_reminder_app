<<<<<<< HEAD
# medical_reminder_app
An app for creating reminders for medicines created using Flutter
=======
---

# 🩺 Simple Medical Reminder App

A Flutter-based mobile application designed to help users manage their medications and stay on track with their health. The app offers a clean and intuitive user interface with customizable features to enhance user experience.

---

## 📱 App Features

1. **Welcome Page**  
   - Displays motivational health quotes.  
   - A "Get Started" button to guide users.  
   - Light pink accent theme (pink, pink accent, white).  
   - This page is displayed only during the first app launch.

2. **Login Page**  
   - A visually appealing layout with a heart icon and app name.  
   - Welcomes users with motivational messages like:  
     - "Let's sign you in"  
     - "Welcome back"  
     - "You have been missed."  
   - Fields for entering user details:  
     - Name  
     - Age  
   - Redirects users to the Home Page after login.  
   - Login Page is shown only once after installation.

3. **Home Page**  
   - Contains three areas for daily, weekly and monthly consumed medicines. 
   - **Daily** section:  
     - Lists medications the user is taking daily.  
     - Empty by default.  
     - Add new medicines via a Floating Action Button (`+`).  
   - **Weekly** section:  
     - Lists medications the user is taking weekly.  
     - Empty by default.  
     - Add new medicines via a Floating Action Button (`+`).  
   - **Monthly** section:  
     - Lists medications the user is taking monthly.  
     - Empty by default.  
     - Add new medicines via a Floating Action Button (`+`).  
   - Floating Action Button (`+`) navigates the user to AddReminderPage. 
   - User can edit and delete already created medicines using the three dots in each medicine tile. 
   - The edit option in the context menu navigates the user to the EditReminderPage. 
   - Medicine Tile:  
     - Displays medicine name, type (tablet, syrup, injection), and intake time (e.g., 'before dinner,' 'after breakfast').  

4. **Add Reminder Page**
   - Contains options for. 
    - Entering the name of the medicine. 
    - Selecting the type of the medicine, i.e. syrup, tablet or injection. 
    - Adding the time and schedule of consumption. 
    - Entering the duration of the course. 
    - Selecting the frequency of the medicine, i.e. daily, weekly or monthly. 
   - A button for saving the medicine in the database. 

5. **Edit Reminder Page**
   - Contains options for
    - Entering the new name of the medicine. 
    - Reselecting the type of the medicine, i.e. syrup, tablet or injection. 
    - Adding new timings and removing the existing timings. 
    - Changing the duration of the course. 
    - Reselecting the frequency of the medicine, i.e. daily, weekly or monthly. 
   - A button to save the changes. 

6. **Settings Page**
   - Contains options for changing the notification time.
   - User can change the notification time for medicines before breakfast, after breakfast, before lunch, after lunch, before dinner and after dinner. 

7. **Profile Page**  
   - Displays user details with a circular avatar.  
   - Editable user profile (Name and Age).  
   - **Ongoing Courses** section:  
     - Lists medications the user is taking.  
     - Empty by default.  
   - Medicine Tile:  
     - Displays medicine name, type (tablet, syrup, injection), and intake time (e.g., 'before dinner,' 'after breakfast').  

8. **Database**  
   - Persistent data storage using [Hive](https://pub.dev/packages/hive).  

9. **Dynamic Navigation**  
   - Welcome and Login pages are displayed only once.  
   - Subsequent app launches redirect users directly to the Home Page.  
   - User can use bottom navigation bar or swipe the screen to navigate to home, settings and profile page. 

---


## 💾 Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)  
- **Programming Language**: Dart  
- **Database**: [Hive](https://pub.dev/packages/hive)

---

## 🎨 Design

The app design is inspired by the **Top Medication Pill Reminder Apps** project on Behance. Modifications were made to ensure a unique and user-friendly interface.

---

## 📂 Directory Structure

```plaintext
lib/
├── main.dart           # Entry point of the app. 
├── pages/              # Contains all the pages (Welcome, Login, Profile, etc.). 
├── assets/             # Custom reusable widgets. 
└── services/           # Contains Notification service. 
```

---

## 🤝 Contributing

Contributions are welcome!  
Feel free to fork this repository, make changes, and submit a pull request.  

---


## 🛠 Future Enhancements

- Support for multiple user profiles.  
- Calendar-based medication tracking.  
- Dark mode for better accessibility.  
- A page for tracking previous health reports and plotting a graph with previous medical reports for easy comparisons. 

---

## 👨‍💻 Author

Alvin A S (https://github.com/Alvin0305). 

--- 
>>>>>>> c5c80c3 (medical app)
