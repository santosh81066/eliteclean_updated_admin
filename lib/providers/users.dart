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
    required WidgetRef ref,
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
      final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().register}';
      print("Register URL: $url");

      var request = http.MultipartRequest('POST', Uri.parse(url));
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
        'bankaccountno': bankAccountNo,
        'bankname': bankName,
        'ifsccode': ifscCode,
        'radius': radius == "" ? null : radius,
      };

      request.fields['attributes'] = jsonEncode(attributes);
      request.files.add(
          await http.MultipartFile.fromPath('profilepic', profilePic.path));
      request.files
          .add(await http.MultipartFile.fromPath('id_front', idFront.path));
      request.files
          .add(await http.MultipartFile.fromPath('id_back', idBack.path));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response status: ${response.statusCode}');
      print('Response body: $responseBody');

      var parsedResponse = jsonDecode(responseBody);
      final messages = List<String>.from(parsedResponse['messages'] ?? []);
      final message = messages.join("\n");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(response.statusCode == 201 ? "Success" : "Error"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (response.statusCode == 201)
                    Navigator.of(context).pushNamed('/home');
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error during registration: $e');
      _showErrorDialog(
          context, 'An error occurred during user registration: $e');
    } finally {
      loader.state = false;
    }
  }

  // GET request to fetch users (combined fetchUserDetails and fetchUsers)
  Future<void> fetchUsers({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    var loader = ref.read(loadingProvider.notifier);
    loader.state = true;
    try {
      final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().login}';
      print("Fetching users from: $url");

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 201) {
        var responseBody = jsonDecode(response.body);
        print('Users: $responseBody');
        final newUserState = UserState.fromJson(responseBody);
        state = state.copyWith(
          statusCode: newUserState.statusCode,
          success: newUserState.success,
          messages: newUserState.messages,
          data: newUserState.data,
        );
        print("userDetails: ${state.data[0].userId}");
      } else {
        print('Failed to fetch users: ${response.body}');
        _showErrorDialog(context, 'Failed to fetch users.');
      }
    } catch (e) {
      print('Error fetching users: $e');
      _showErrorDialog(context, 'An error occurred: $e');
    } finally {
      loader.state = false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
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
}

final usersProvider = StateNotifierProvider<Users, UserState>((ref) {
  return Users();
});
