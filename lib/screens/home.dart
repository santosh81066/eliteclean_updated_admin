import 'package:eliteclean_admin/screens/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth.dart';
import '../widgets/topSectionCleaner.dart';
import 'bookings.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation logic here for each index if required
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final List<Widget> pages = [
      // Home Page
      const Home(),
      UserScreen(),
      BookingScreen(),
      // Settings Page

      // Notifications Page
      const Center(
        child: Text(
          'Notifications Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // Changed from `drawer` to `endDrawer` to open from the right
      endDrawer: MyDrawer(),
      body: _selectedIndex == 0
          ? Column(
              children: [
                Stack(
                  children: [
                    // Purple header section
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.25,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6D6BE7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45),
                          bottomRight: Radius.circular(45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 50.0, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 40),
                            Consumer(
                              builder: (context, ref, child) {
                                var username = ref.read(authProvider);
                                return Text(
                                  'Hi ${username.data!.username},',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                            const Text(
                              'Need some help today?',
                              style: TextStyle(
                                color: Color(0xFFF8F8FA),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Custom toggle button to open drawer
                    Positioned(
                      top: screenHeight * 0.10,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: 0.7,
                              child: Container(
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFEAE9FF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(100),
                                      bottomLeft: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    ),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x266D6BE7),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 30,
                                  height: 5, // Increased thickness
                                  color:
                                      Colors.white, // White color for the line
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 30,
                                  height: 5, // Increased thickness
                                  color:
                                      Colors.white, // White color for the line
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Main content section (Your Packages and Services)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Today's work",
                          style: TextStyle(
                            color: Color(0xFF1E116B),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : pages.elementAt(_selectedIndex),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 15,
        selectedItemColor: const Color(0xFF583EF2),
        unselectedItemColor: const Color(0xFF77779D),
        currentIndex: _selectedIndex, // Set the currently selected index
        onTap: _onItemTapped, // Update selected index when a tab is tapped
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.supervised_user_circle),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
        ],
      ),
    );
  }
}

//side Drawer
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header for the drawer with profile information

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0x4d000000),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(100),
                            bottomLeft: Radius.circular(100),
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Icon(
                          Icons.image,
                          color: Colors.grey[300],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Janet Anderson",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "123 points",
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // List of drawer items
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  text: 'Profile',
                  onTap: () {},
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
                _buildDrawerItem(
                  icon: Icons.card_giftcard_outlined,
                  text: 'Promotion',
                  onTap: () {},
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  text: 'Setting',
                  onTap: () {},
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
                _buildDrawerItem(
                  icon: Icons.support_agent_outlined,
                  text: 'Support',
                  onTap: () {},
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
                _buildDrawerItem(
                  icon: Icons.policy_outlined,
                  text: 'Policy',
                  onTap: () {},
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
                _buildDrawerItem(
                  icon: Icons.logout_outlined,
                  text: 'Log out',
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
                Divider(
                  color: Color(0x0d000000),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to create a drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color(0xFF6D6BE7),
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
