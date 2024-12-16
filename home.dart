import 'dart:async';
import 'package:flutter/material.dart';
import 'package:signup/home_cards/excercise.dart';
import 'package:signup/inspection.dart';
import 'package:signup/pages/Signuppage.dart';
import 'package:signup/home_cards/chatbot.dart';
import 'package:signup/home_cards/map.dart';
import 'package:signup/pages/signinpage.dart';

import 'pages/aboutpage.dart';
import 'pages/settingpage.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0; // Track the selected tab

  // List of widgets for each page
  final List<Widget> _screens = [
    const HomeScreen(),  // The current Home screen
    const AboutScreen(), // Placeholder for About screen
    const SettingsScreen(), // Placeholder for Settings screen
  ];

  // Method to handle bottom navigation bar tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue, // Start color
              Colors.white, // End color
            ],
            begin: Alignment.topCenter, // Start from the top
            end: Alignment.bottomCenter, // End at the bottom
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 70), // Add some space from the top
            const Text(
              'Knee-Care Pro', 
              style: TextStyle(
                fontSize: 39, 
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20), // Space between title and description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Disclaimer: This app is not a substitute for professional medical advice, diagnosis, or treatment. ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 10, 76, 120)),
              ),
            ),
            Expanded(
              child: _screens[_selectedIndex], // Display the current screen based on selected index
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the top row of cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(context, 0),
              const SizedBox(width: 10), 
              _buildCard(context, 1),
            ],
          ),
          const SizedBox(height: 20), // Space between rows
          // Display the bottom row of cards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(context, 2),
              const SizedBox(width: 10), // Space between cards
              _buildCard(context, 3), // Fourth card added here
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, int position) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Navigate based on the card tapped
          if (position == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          } else if (position == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ExerciseScreen()),
            );
          } else if (position == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GoogleMapPage()),
            );
          }
          else if (position == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ClassificationScreen()),
            );
          }
          
        },
        child: SizedBox(
          width: 170, // Increased width
          height: 170, // Increased height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                position == 0
                    ? Icons.chat
                    : position == 1
                        ? Icons.fitness_center
                        : position == 2
                            ? Icons.map
                            : Icons.manage_search_sharp, 
                size: 65, // Increased icon size
                color: position == 0
                    ? Colors.purple
                    : position == 1
                        ? Colors.green
                        : position == 2
                            ? Colors.red
                            : Colors.orange, 
              ),
              const SizedBox(height: 10),
              Text(
                position == 0
                    ? 'Chatbot'
                    : position == 1
                        ? 'Exercises'
                        : position == 2
                            ? 'Map'
                            : 'Inspection', 
                style: const TextStyle(fontSize: 16), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
