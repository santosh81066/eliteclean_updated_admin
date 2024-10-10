import 'package:eliteclean_admin/models/users.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch users when the widget is initialized
      ref.read(usersProvider.notifier).fetchUsers(ref: ref, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final userState = ref.watch(usersProvider); // Watch the provider

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
                context, '/register'); // Navigate to register route
          },
          backgroundColor: const Color(0xFF6D6BE7),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
          children: [
            TopSection(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              scaffoldKey: _scaffoldKey,
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
              child: _buildContent(userState),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(UserState userState) {
    if (userState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (userState.error != null) {
      return Center(child: Text('Error: ${userState.error}'));
    } else {
      // Filter users based on their role
      final allUsers = userState.users;
      final supervisorUsers =
          allUsers.where((user) => user.useRole == 's').toList();
      final cleanerUsers =
          allUsers.where((user) => user.useRole == 'u').toList();

      return TabBarView(
        children: [
          // Tab 1: All users
          UserListView(users: allUsers),
          // Tab 2: Supervisor users
          UserListView(users: supervisorUsers),
          // Tab 3: Cleaner users
          UserListView(users: cleanerUsers),
        ],
      );
    }
  }
}

class UserListView extends StatelessWidget {
  final List<Data> users;

  const UserListView({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found.'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Card(
          color: const Color(0xffF5F5F5),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Icon(Icons.person, color: Colors.grey),
                ),
                const SizedBox(width: 25),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User ID',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF1E116B),
                        ),
                      ),
                      Text(
                        '${user.userId}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Username',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E116B),
                        ),
                      ),
                      Text(
                        user.username ?? 'N/A',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Mobile no.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E116B),
                        ),
                      ),
                      Text(
                        user.mobileno ?? 'N/A',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1E116B),
                        ),
                      ),
                      Text(
                        _getRoleName(user.useRole ?? ''),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getRoleName(String role) {
    switch (role) {
      case 's':
        return 'Supervisor';
      case 'u':
        return 'Cleaner';
      default:
        return 'Unknown';
    }
  }
}
