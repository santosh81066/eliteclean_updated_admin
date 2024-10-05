import 'package:eliteclean_admin/providers/addressnotifier.dart';
import 'package:eliteclean_admin/providers/loader.dart';
import 'package:eliteclean_admin/providers/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../providers/imagenotifier.dart';
import '../providers/navigation_provider.dart';
import '../widgets/topSectionProfile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  XFile? _frontImage;
  XFile? _backImage;

  Future<void> _pickFrontImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _frontImage = XFile(pickedFile.path);
      });
    }
  }

  Future<void> _pickBackImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _backImage = XFile(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> registrationData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String mobileNumber = registrationData['mobileNumber'];
    final String country = registrationData['country'];
    final String state = registrationData['state'];
    final String city = registrationData['city'];
    final String address = registrationData['address'];
    final String radius = registrationData['radius'];
    final String status = registrationData['status'];
    final String role = registrationData['role'];

    // Grab new fields for bank details
    final String bankAccountNo = registrationData['bankAccountNo'];
    final String bankName = registrationData['bankName'];
    final String ifscCode = registrationData['ifscCode'];

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingHorizontal =
        screenWidth * 0.04; // 4% of screen width for horizontal padding

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Ensures column content is aligned left
          children: [
            TopSectionProfile(
                screenWidth: screenWidth, screenHeight: screenHeight),

            // Main content section (Your Packages and Services)
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      paddingHorizontal), // Responsive horizontal padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: screenHeight *
                          0.04), // 4% of screen height for spacing
                  const Text(
                    'Upload ID Card Image',
                    style: TextStyle(
                      color: Color(0xFF583EF2),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.02), // 2% of screen height for spacing
                  const Text(
                    'Front side',
                    style: TextStyle(
                      color: Color(0xFF1E116B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                      height: screenHeight *
                          0.01), // 1% of screen height for spacing
                  Consumer(
                    builder: (context, ref, child) {
                      final imageState = ref.watch(imageProvider);
                      final imageNotifier = ref.read(imageProvider.notifier);
                      return GestureDetector(
                        onTap: imageNotifier.pickFrontImage,
                        child: Container(
                          width: screenWidth *
                              0.25, // 25% of screen width for image
                          height: screenWidth * 0.25, // Maintain square shape
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.01),
                              topRight: Radius.circular(screenWidth * 0.16),
                              bottomLeft: Radius.circular(screenWidth * 0.16),
                              bottomRight: Radius.circular(screenWidth * 0.16),
                            ),
                            color: const Color(0xffffffff),
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: const Color(0xffEAEAFF),
                              width: 1.5,
                            ),
                            image: imageState.frontImage != null
                                ? DecorationImage(
                                    image: FileImage(
                                        File(imageState.frontImage!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _frontImage == null
                              ? Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                  size: screenWidth *
                                      0.1, // Adjust icon size relative to screen width
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  const Text(
                    'Back side',
                    style: TextStyle(
                      color: Color(0xFF1E116B),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Consumer(
                    builder: (context, ref, child) {
                      final imageState = ref.watch(imageProvider);
                      final imageNotifier = ref.read(imageProvider.notifier);
                      return GestureDetector(
                        onTap: imageNotifier.pickBackImage,
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: const Color(0xffEAEAFF),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(screenWidth * 0.01),
                              topRight: Radius.circular(screenWidth * 0.16),
                              bottomLeft: Radius.circular(screenWidth * 0.16),
                              bottomRight: Radius.circular(screenWidth * 0.16),
                            ),
                            image: imageState.backImage != null
                                ? DecorationImage(
                                    image: FileImage(
                                        File(imageState.backImage!.path)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _backImage == null
                              ? Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                  size: screenWidth * 0.1, // Adjust icon size
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(
                height: screenHeight * 0.1), // 10% of screen height for spacing
            Center(
              child: SizedBox(
                width:
                    screenWidth * 0.80, // Button width at 80% of screen width
                child: Consumer(
                  builder: (context, ref, child) {
                    final imageState =
                        ref.watch(imageProvider); // Listen to image state
                    var loader = ref.watch(loadingProvider);
                    var location = ref.read(addressProvider);
                    return ElevatedButton(
                      onPressed: loader == true
                          ? null
                          : () {
                              ref.read(usersProvider.notifier).registerUser(
                                  context: context,
                                  ref: ref,
                                  mobileNo: mobileNumber,
                                  latitude: location.latitude!,
                                  longitude: location.latitude!,
                                  city: city,
                                  state: state,
                                  countryname: country,
                                  address: address,
                                  role: role,
                                  userstatus: status,
                                  bankAccountNo: bankAccountNo,
                                  bankName: bankName,
                                  ifscCode: ifscCode,
                                  radius: radius,
                                  profilePic: imageState.profileImage!,
                                  idFront: imageState.frontImage!,
                                  idBack: imageState.backImage!);
                            },
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: const Color(
                            0xFF583EF2), // Set same color for disabled state
                        disabledForegroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical:
                                screenHeight * 0.02), // Responsive padding
                        backgroundColor: const Color(0xFF583EF2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth * 0.04), // Responsive corner radius
                        ),
                      ),
                      child: loader == true
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
