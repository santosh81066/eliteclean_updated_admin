import 'dart:convert';
import 'dart:io';

import 'package:eliteclean_admin/providers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/eliteclean_api.dart';

class Users extends StateNotifier<String> {
  Users() : super('');

  Future<void> registerUser({
    WidgetRef? ref,
    required BuildContext context, // Add context for displaying alerts
    required String mobileNo,
    required double latitude,
    required double longitude,
    required String city,
    required String state,
    required String countryname,
    required String address,
    required String role,
    required String userstatus,
    required String bankAccountNo,
    required String bankName,
    required String ifscCode,
    required String radius,
    required XFile profilePic,
    required XFile idFront,
    required XFile idBack,
  }) async {
    var loader = ref!.read(loadingProvider.notifier);
    try {
      loader.state = true;
      final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().register}';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      print("register url:$url");

      // Create the attributes object as JSON, just like in Postman
      Map<String, dynamic> attributes = {
        'mobileno': mobileNo,
        'location': {
          'latitude': latitude,
          'longitude': longitude,
          'city': city,
          'state': state,
          'countryname': countryname,
          'address': address,
        },
        'role': role,
        'userstatus': userstatus,
        'banckaccountno': bankAccountNo,
        'bankname': bankName,
        'ifsccode': ifscCode,
        'radius': radius,
      };

      // Add the attributes JSON as a string
      request.fields['attributes'] = jsonEncode(attributes);

      // Add file fields
      request.files.add(
          await http.MultipartFile.fromPath('profilepic', profilePic.path));
      request.files
          .add(await http.MultipartFile.fromPath('id_front', idFront.path));
      request.files
          .add(await http.MultipartFile.fromPath('id_back', idBack.path));

      // Send the request
      var response = await request.send();

      // Read the response body for more details
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      loader.state = false;

      // Parse the response
      var parsedResponse = jsonDecode(responseBody);

      // Check the response status
      if (response.statusCode == 201) {
        // Extract the message from the response
        List<String> messages = List<String>.from(parsedResponse['messages']);
        String message = messages.join("\n");

        // User registered successfully, show message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: Text(message), // Display messages from response
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/home'); // Close the dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // Extract error messages and display
        List<String> messages = List<String>.from(parsedResponse['messages']);
        String message = messages.join("\n");

        // Handle failure, show message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message), // Display error messages
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      loader.state = false;

      // Handle error with an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('An error occurred during user registration: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}

final usersProvider = StateNotifierProvider<Users, String>((ref) {
  return Users();
});
