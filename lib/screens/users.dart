import 'package:flutter/material.dart';
import '../widgets/topSectionCleaner.dart'; // Ensure this points to the right file

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  // Create a GlobalKey for ScaffoldState to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey, // Assign the GlobalKey to Scaffold
      // Drawer widget
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Registration Screen when FAB is pressed
          Navigator.pushNamed(
              context, '/register'); // Navigate to register route
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // '+' icon
        backgroundColor: const Color(0xFF6D6BE7), // Customize button color
      ),

      // Main Body
      body: Column(
        children: [
          // Pass scaffoldKey and other parameters to TopSection
          TopSection(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            scaffoldKey: _scaffoldKey, // Pass the scaffoldKey here
          ),
          // List of users (example)
          Expanded(
            child: ListView(
              children: [
                // Example User Card
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('John Doe'),
                  subtitle: const Text('john.doe@example.com'),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    // Handle user tap (e.g., edit user)
                  },
                ),
                // You can add more user list tiles here
              ],
            ),
          )
        ],
      ),
    );
  }
}
