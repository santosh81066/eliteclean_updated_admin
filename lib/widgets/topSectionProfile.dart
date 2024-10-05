import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../providers/imagenotifier.dart';
// Import your image provider

class TopSectionProfile extends ConsumerWidget {
  const TopSectionProfile({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageState = ref.watch(imageProvider); // Listen to image state
    final imageNotifier =
        ref.read(imageProvider.notifier); // For updating images

    return Container(
      height: screenHeight * 0.32,
      child: Stack(
        children: [
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
            child: const Padding(
              padding: EdgeInsets.only(top: 50.0, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Upload profile image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: (screenWidth - 100) / 2, // Center the image
            child: GestureDetector(
              onTap: () => imageNotifier.pickProfileImage(),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(64),
                    bottomLeft: Radius.circular(64),
                    bottomRight: Radius.circular(64),
                  ),
                  color: const Color(0xffffffff),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Color(0xffEAEAFF),
                    width: 1.5,
                  ),
                  image: imageState.profileImage != null
                      ? DecorationImage(
                          image: FileImage(File(imageState.profileImage!.path)),
                          fit: BoxFit.cover,
                        )
                      : null, // Display profile image if selected
                ),
                child: imageState.profileImage == null
                    ? const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                        size: 40,
                      )
                    : null, // If no image, display camera icon
              ),
            ),
          ),
        ],
      ),
    );
  }
}
