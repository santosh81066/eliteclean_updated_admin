import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';

class TopSection extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const TopSection({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
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
              // Open the drawer using the scaffold key
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
                      color: Colors.white, // White color for the line
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 30,
                      height: 5, // Increased thickness
                      color: Colors.white, // White color for the line
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header for the drawer with profile information
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFF8F8FA), // Background color of the drawer header
            ),
            accountName: Text(
              "Janet Anderson",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            accountEmail: Text(
              "123 points",
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                  'assets/profile_image.jpg'), // Add your asset image path here
              radius: 50.0,
            ),
          ),

          // List of drawer items
          _buildDrawerItem(
            icon: Icons.person_outline,
            text: 'Profile',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.card_giftcard_outlined,
            text: 'Promotion',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Setting',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.support_agent_outlined,
            text: 'Support',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.policy_outlined,
            text: 'Policy',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.logout_outlined,
            text: 'Log out',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Helper function to create a drawer item
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    GestureTapCallback? onTap,
  }) {
    return ListTile(
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
    );
  }
}
