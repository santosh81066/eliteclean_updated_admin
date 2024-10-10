import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/topSectionCleaner.dart'; // Ensure this points to the right file
import '../providers/users.dart'; // Import the provider

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  // Create a GlobalKey for ScaffoldState to control the drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final users = ref
        .watch(usersProvider)
        .data; // Assuming 'users' is a list of 'Data' objects

    // Filter users based on their role
    final allUsers = users; // All users
    final supervisorUsers =
        users.where((user) => user.useRole == 's').toList(); // Supervisors
    final cleanerUsers =
        users.where((user) => user.useRole == 'u').toList(); // Cleaners

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey, // Assign the GlobalKey to Scaffold
        // Drawer widget
        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to Registration Screen when FAB is pressed
            Navigator.pushNamed(
                context, '/register'); // Navigate to register route
          },
          backgroundColor: const Color(0xFF6D6BE7),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ), // Customize button color
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
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicatorColor: Color(0xFF583EF2),
              labelColor: Color(0xFF1E116B),
              unselectedLabelColor: Color(0xFFB8B8D2),
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Supervisor'),
                Tab(text: 'Cleaner'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Tab 1: All users
                  ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final user = allUsers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ID: ${user.userId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Username: ${user.username ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Role: ${user.useRole}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Tab 2: Supervisor users
                  ListView.builder(
                    itemCount: supervisorUsers.length,
                    itemBuilder: (context, index) {
                      final user = supervisorUsers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ID: ${user.userId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Username: ${user.username ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Role: ${user.useRole}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Tab 3: Cleaner users
                  ListView.builder(
                    itemCount: cleanerUsers.length,
                    itemBuilder: (context, index) {
                      final user = cleanerUsers[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User ID: ${user.userId}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Username: ${user.username ?? 'N/A'}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Role: ${user.useRole}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
