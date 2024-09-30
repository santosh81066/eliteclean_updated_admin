import 'package:eliteclean_admin/providers/auth.dart';
import 'package:eliteclean_admin/providers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../providers/navigation_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    username.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  height: screenHeight * 0.1), // Space from top to the logo

              // Logo at the top
              SvgPicture.asset(
                'assets/images/logo-icon.svg', // Path to your SVG file
                fit: BoxFit.contain, // Adjust fit as needed
              ),

              const SizedBox(height: 16),

              // "Sign up" text
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E116B),
                ),
              ),
              const SizedBox(height: 8),

              // Subtext
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Please enter your details to Login.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF77779D),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Form container (expanded towards the bottom)
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 32),
                height: screenHeight * 0.60, // Adjust height of the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: const Color(0xFFEAE9FF)),
                ),
                child: Column(
                  // Align the button at the bottom
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form fields
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Your name" label and input field
                        const Text(
                          'User Name',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xFFB8B8D2)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: username,
                                decoration: const InputDecoration(
                                  hintText: 'user name here',
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Color(0xFFB8B8D2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F39),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.lock, color: Color(0xFFB8B8D2)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: password,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  hintText: 'your password here',
                                  border: InputBorder.none,
                                  hintStyle:
                                      TextStyle(color: Color(0xFFB8B8D2)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 30),
                    // "Next" button aligned at the bottom and full width
                    SizedBox(
                      width:
                          double.infinity, // Makes the button take full width
                      child: Consumer(
                        builder: (context, ref, child) {
                          var login = ref.read(authProvider.notifier);
                          var loader = ref.watch(loadingProvider.notifier);
                          return ElevatedButton(
                            onPressed: loader.state == true
                                ? null
                                : () {
                                    login.login(ref,
                                        username: username.text.trim(),
                                        password: password.text.trim());
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: const Color(0xFF583EF2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: loader.state == true
                                ? CircularProgressIndicator()
                                : const Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors
                                          .white, // Set text color to white
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
