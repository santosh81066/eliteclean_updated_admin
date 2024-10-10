import 'dart:convert';
import 'package:eliteclean_admin/models/users.dart';
import 'package:eliteclean_admin/providers/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../utils/eliteclean_api.dart';

class Users extends StateNotifier<UserState> {
  Users() : super(UserState.initial());

  // POST request to register a user
  Future<void> registerUser({
    WidgetRef? ref,
    required BuildContext context,
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
      print("Register URL: $url");

      // Define the request correctly as http.MultipartRequest
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Create the attributes object as JSON
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

      var parsedResponse = jsonDecode(responseBody);

      if (response.statusCode == 201) {
        List<String> messages = List<String>.from(parsedResponse['messages']);
        String message = messages.join("\n");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        List<String> messages = List<String>.from(parsedResponse['messages']);
        String message = messages.join("\n");

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('An error occurred during user registration: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // GET request to fetch user details
  Future<void> fetchUserDetails({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var loader = ref.read(loadingProvider.notifier);
    try {
      loader.state = true;
      final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().login}';
      print("Fetching user details from: $url");

      // Send the GET request
      final response = await http.get(Uri.parse(url));
      var responseBody = jsonDecode(response.body);
      print('User Details: $responseBody');
      // Check if request was successful
      if (response.statusCode == 200) {
        loader.state = false;

        // Display user details in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("User Details"),
              content: Text('User Data: $responseBody'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        loader.state = false;
        print('Failed to fetch user details: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text('Failed to fetch user details.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
      print('Error fetching user details: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    }
  }

  // GET request to fetch users via login endpoint
  Future<void> fetchUsers({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var loader = ref.read(loadingProvider.notifier);
    try {
      loader.state = true;
      final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().login}';
      print("Fetching users from: $url");

      // Send the GET request
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        print('Users: $responseBody');
        final newUserState = UserState.fromJson(responseBody);
        state = state.copyWith(
          statusCode: newUserState.statusCode,
          success: newUserState.success,
          messages: newUserState.messages,
          data: newUserState.data, // Update with the list of Data objects
        );
        print("userDetails: ${state.data[0].userId}");
        loader.state = false;

        print('User Data: $responseBody');
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text("Users"),
        //       content: Text('User Data: $responseBody'),
        //       actions: <Widget>[
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text("OK"),
        //         ),
        //       ],
        //     );
        //   },
        // );
      } else {
        loader.state = false;
        print('Failed to fetch users: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text('Failed to fetch users.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
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
      print('Error fetching users: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text('An error occurred: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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

final usersProvider = StateNotifierProvider<Users, UserState>((ref) {
  return Users();
});
