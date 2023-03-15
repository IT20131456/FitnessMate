import 'package:fitness_mate/screens/fitness_reminder/reminder_dashboard.dart';
import 'package:flutter/material.dart';
import './my_drawer_header.dart';
import './contacts.dart';
import './dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_mate/screens/login_screen.dart';
import 'package:fitness_mate/screens/wellness_reports/bmi_reports_view_screen.dart';
import 'package:fitness_mate/screens/meal_logger/meal_logger_main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = DashboardPage();
    } else if (currentPage == DrawerSections.contacts) {
      container = ContactsPage();
    } else if (currentPage == DrawerSections.bmireport) {
      container = BmiReportsView();
    } else if (currentPage == DrawerSections.reminder) {
      container = ReminderDashboard();
    } else if (currentPage == DrawerSections.mealLogger) {
      container = MealLoggerMainScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Fitness Mate')),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  final navigator = Navigator.of(context);
                  await FirebaseAuth.instance.signOut();
                  navigator.pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Icon(Icons.logout),
              )),
        ],
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Contacts", Icons.people_alt_outlined,
              currentPage == DrawerSections.contacts ? true : false),
          menuItem(3, "BMI Reports", Icons.people_alt_outlined,
              currentPage == DrawerSections.bmireport ? true : false),
          menuItem(4, "Reminders", Icons.alarm,
              currentPage == DrawerSections.reminder ? true : false),
          menuItem(5, "Meal Logger", Icons.food_bank_outlined,
              currentPage == DrawerSections.mealLogger ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.contacts;
            } else if (id == 3) {
              currentPage = DrawerSections.bmireport;
            } else if (id == 4) {
              currentPage = DrawerSections.reminder;
            } else if (id == 5) {
              currentPage = DrawerSections.mealLogger;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  contacts,
  bmireport,
  reminder,
  mealLogger,
}
