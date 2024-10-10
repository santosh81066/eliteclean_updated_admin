import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth.dart';
import 'screens/cleaner_registration.dart';
import 'screens/holidayapplication.dart';
import 'screens/home.dart';
import 'screens/loginpage.dart';
import 'screens/otpverify.dart';
import 'screens/payment_info.dart';
import 'screens/slashscreen.dart';
import 'screens/userprofile.dart';
import 'supervisor_screens/allcleaners_supervisor.dart';
import 'supervisor_screens/holiday_applications.dart';
import 'supervisor_screens/home_supervisor.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EliteClean',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the initial route and the routes in the app
      initialRoute: '/',
      routes: {
        '/': (context) {
          return Consumer(
            builder: (context, ref, child) {
              final authState = ref.watch(authProvider);

              // Check if the user has a valid refresh token
              if (authState.data?.refreshToken != null &&
                  authState.data!.refreshToken!.isNotEmpty) {
                print('Refresh token exists: ${authState.data?.refreshToken}');
                return const Home(); // User is authenticated, redirect to Home
              } else {
                print('No valid refresh token, trying auto-login');
              }

              // Attempt auto-login if refresh token is not in state
              return FutureBuilder(
                future: ref.watch(authProvider.notifier).tryAutoLogin(),
                builder: (context, snapshot) {
                  print(
                      'Token after auto-login attempt: ${authState.data?.accessToken}');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    ); // Show SplashScreen while waiting
                  } else if (snapshot.hasData &&
                      snapshot.data == true &&
                      authState.data?.refreshToken != null) {
                    // If auto-login is successful and refresh token is available, go to Home
                    return const Home();
                  } else {
                    // If auto-login fails, redirect to login page
                    return const Login();
                  }
                },
              );
            },
          );
        },
        '/login': (context) => const Login(),
        '/verify': (context) => const Verify(),
        '/register': (context) => const CleanerRegistration(),
        '/userprofile': (context) => const UserProfile(),
        '/paymentinfo': (context) => const PaymentInfo(),
        '/home': (context) => const Home(),
        '/homesupervisor': (context) => const HomeSupervisor(),
        '/applyholiday': (context) => const ApplyHoliday(),
        '/allcleaners': (context) => AllCleaners(),
        '/holidayapps': (context) => HolidayApps(),
      },
    );
  }
}
