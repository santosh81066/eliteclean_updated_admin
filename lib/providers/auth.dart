// providers/authnotifier.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/authstate.dart';
import '../utils/eliteclean_api.dart';
import 'loader.dart';

// Define the AuthNotifier with StateNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  // Login function
  Future<void> login(
    WidgetRef ref, {
    required String username,
    required String password,
  }) async {
    print("Login API call started for user: $username");

    // Start loading indicator
    var loader = ref.read(loadingProvider.notifier);
    loader.state = true;

    // Define the URL for the login API
    final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().login}';

    // Fetch shared preferences instance to store user data
    final prefs = await SharedPreferences.getInstance();

    try {
      // Prepare headers and body
      final headers = {
        'Content-Type': 'application/json',
      };
      final body = json.encode({
        "username": username,
        "password": password,
      });

      // Print the Content-Type header before making the API call
      print("Request Headers: $headers");

      // Make the POST request to the login API with username and password
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Parse the response body
      var responseData = json.decode(response.body);
      print('Login API response: $responseData');

      // Handle different status codes
      switch (response.statusCode) {
        case 401:
          print("Unauthorized (401) - Invalid username or password");
          loader.state = false;
          // Optionally, update state with an error message
          state = state.copyWith(messages: ["Invalid credentials."]);
          break;

        case 200:
          print("Login success - Access and refresh tokens received");
          final authState = AuthState.fromJson(responseData);
          final newAccessToken = authState.data?.accessToken;
          final newAccessTokenExpiryDate =
              authState.data?.accessTokenExpiresAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      authState.data!.accessTokenExpiresAt!)
                  : null;
          final newRefreshToken = authState.data?.refreshToken;
          final newRefreshTokenExpiryDate =
              authState.data?.refreshTokenExpiresAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      authState.data!.refreshTokenExpiresAt!)
                  : null;

          // Update state and save to SharedPreferences
          state = state.copyWith(
            data: authState.data?.copyWith(
              accessToken: newAccessToken,
              accessTokenExpiresAt:
                  newAccessTokenExpiryDate?.millisecondsSinceEpoch,
              refreshToken: newRefreshToken,
              refreshTokenExpiresAt:
                  newRefreshTokenExpiryDate?.millisecondsSinceEpoch,
            ),
          );

          final userData = json.encode({
            'username': authState.data?.username,
            'accessToken': newAccessToken,
            'accessTokenExpiry': newAccessTokenExpiryDate?.toIso8601String(),
            'refreshToken': newRefreshToken,
            'refreshTokenExpiry': newRefreshTokenExpiryDate?.toIso8601String(),
            'userId': authState.data?.userId,
            'countryname': authState.data?.countryname,
            'state': authState.data?.state,
            'city': authState.data?.city,
            'address': authState.data?.address,
            'profile_pic': authState.data?.profilePic,
            'use_role': authState.data?.useRole,
            'id_front': authState.data?.idFront,
            'id_back': authState.data?.idBack,
            'id_card': authState.data?.idCard,
            'bankaccountno': authState.data?.bankaccountno,
            'bankname': authState.data?.bankname,
            'ifsccode': authState.data?.ifsccode,
            'latitude': authState.data?.latitude,
            'longitude': authState.data?.longitude,
            'radius': authState.data?.radius,
          });

          loader.state = false;
          await prefs.setString('userData', userData);
          print(
              "SharedPreferences updated with new token data: ${prefs.getString('userData')}");
          break;

        default:
          print("Unhandled status code: ${response.statusCode}");
          loader.state = false;
          // Optionally, update state with an error message
          state = state.copyWith(
            messages: ["An unexpected error occurred. Please try again."],
          );
          break;
      }
    } on FormatException catch (formatException) {
      print('Format Exception: ${formatException.message}');
      print('Invalid response format.');
      state = state.copyWith(
        messages: ["Invalid response from server."],
      );
    } on HttpException catch (httpException) {
      print('HTTP Exception: ${httpException.message}');
      state = state.copyWith(
        messages: ["Network error occurred."],
      );
    } catch (e, stackTrace) {
      print('General Exception: ${e.toString()}');
      print('Stack Trace: $stackTrace');
      state = state.copyWith(
        messages: ["An error occurred. Please try again."],
      );
    } finally {
      loader.state = false;
    }
  }

  Future<void> registerUser() async {
    var url = Uri.parse("https://www.gocodecreations.com/register");

    var request = http.MultipartRequest("POST", url);

    // Add text fields
    request.fields['username'] = 'JohnDoe';
    request.fields['mobileno'] = '8712705508';
    request.fields['role'] = 'u';
    request.fields['userstatus'] = '1';
    request.fields['password'] = 'securePassword123';
    request.fields['id_card'] = 'ID123456789';
    request.fields['banckaccountno'] = '9876543210';
    request.fields['bankname'] = 'Bank of India';
    request.fields['ifsccode'] = 'BOI123456';
    request.fields['radius'] = '10';

    // Add location as a nested JSON object
    var location = {
      "latitude": "28.7041",
      "longitude": "77.1025",
      "city": "New Delhi",
      "state": "Delhi",
      "countryname": "India",
      "address": "1234 Street Name, Area Name"
    };
    request.fields['location'] = jsonEncode(location);

    // Attach file for profilepic, id_front, id_back
    var profilePicPath =
        "/path_to_your_profilepic"; // Change to your image path
    var idFrontPath = "/path_to_your_id_front"; // Change to your image path
    var idBackPath = "/path_to_your_id_back"; // Change to your image path

    request.files
        .add(await http.MultipartFile.fromPath('profilepic', profilePicPath));
    request.files
        .add(await http.MultipartFile.fromPath('id_front', idFrontPath));
    request.files.add(await http.MultipartFile.fromPath('id_back', idBackPath));

    // Send request and wait for the response
    var response = await request.send();

    // Get response as string
    if (response.statusCode == 201) {
      print('User registered successfully');
      var responseBody = await response.stream.bytesToString();
      print(responseBody);
    } else {
      print('Failed to register user. Status code: ${response.statusCode}');
    }
  }

  // Logout function
  Future<void> logout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
    state = AuthState.initial();
  }

  // Auto-login function
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if userData exists in shared preferences
    if (!prefs.containsKey('userData')) {
      print('tryAutoLogin is false');
      return false;
    }

    print("From tryAutoLogin: SharedPreferences contains user data.");

    // Extract user data from shared preferences
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    // Extract individual data fields from the saved data
    final newUser = Data.fromJson(extractedData);

    // Update the AuthState with new data using copyWith
    state = state.copyWith(
      data: newUser, // Updating the state with the restored user data
    );

    // Optional: Log the access token to debug
    print('Access token from tryAutoLogin: ${state.data?.accessToken}');

    return true;
  }
}

// Define the AuthProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
