import 'dart:convert';
import 'dart:io';

import 'package:eliteclean_admin/providers/loader.dart';
import 'package:eliteclean_admin/utils/eliteclean_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/authstate.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState.initial());

  // Future<bool> tryAutoLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print(
  //       "From try auto login SharedPreferences updated with new token data: ${prefs.getString('userData')}");
  //   // Check if userData exists in shared preferences
  //   if (!prefs.containsKey('userData')) {
  //     print('tryAutoLogin is false');
  //     return false;
  //   }
  //   print('try autologin true');

  //   // Extract user data from shared preferences
  //   final extractData =
  //       json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
  //   // print('refresh token : ${extractData['refreshToken']},');
  //   // Get profile existence boolean (default is false if not found)

  //   // Use your models to update the state
  //   final newUser = User(
  //     username: extractData['username'],
  //     countryname: extractData['countryname'],
  //     state: extractData['state'],
  //     city: extractData['city'],
  //     address: extractData['address'],
  //     profilePic: extractData['profile_pic'],
  //     useRole: extractData['use_role'],
  //   );

// php try auto login

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
    final newUser = Data(
      userId: extractedData['userId'],
      username: extractedData['username'],
      countryname: extractedData['countryname'],
      state: extractedData['state'],
      city: extractedData['city'],
      address: extractedData['address'],
      profilePic: extractedData['profile_pic'],
      useRole: extractedData['use_role'],
      idFront: extractedData['id_front'],
      idBack: extractedData['id_back'],
      idCard: extractedData['id_card'],
      bankaccountno: extractedData['bankaccountno'],
      bankname: extractedData['bankname'],
      ifsccode: extractedData['ifsccode'],
      latitude: extractedData['latitude'],
      longitude: extractedData['longitude'],
      radius: extractedData['radius'],
      accessToken: extractedData['accessToken'],
      accessTokenExpiresAt: extractedData['accessTokenExpiry'] != null
          ? DateTime.parse(extractedData['accessTokenExpiry'])
              .millisecondsSinceEpoch
          : null,
      refreshToken: extractedData['refreshToken'],
      refreshTokenExpiresAt: extractedData['refreshTokenExpiry'] != null
          ? DateTime.parse(extractedData['refreshTokenExpiry'])
              .millisecondsSinceEpoch
          : null,
    );

    // Update the AuthState with new data using copyWith
    state = state.copyWith(
      data: newUser, // Updating the state with the restored user data
    );

    // Optional: Log the access token to debug
    print('Access token from tryAutoLogin: ${state.data?.accessToken}');

    return true;
  }

  //   final newTokens = Tokens(
  //     accessToken: extractData['accessToken'],
  //     refreshToken: extractData['refreshToken'],
  //     accessTokenExpiry: extractData['accessTokenExpiry'],
  //     refreshTokenExpiry: extractData['refreshTokenExpiry'],
  //   );

  //   // Update the AuthState with new data using copyWith
  //   state = state.copyWith(
  //     message: 'Auto Login Success',
  //     user: newUser,
  //     tokens: newTokens,
  //   );

  //   // Optional: Log the access token to debug
  //   print('Access token from tryAutoLogin: ${state.tokens?.accessToken}');

  //   return true;
  // }

  // Future<void> login(WidgetRef ref,
  //     {required String username, required String password}) async {
  //   print("Login API call started");
  //   var loader = ref.read(loadingProvider.notifier);
  //   loader.state = true;
  //   // Define the URL for the login API
  //   final url = '${EliteCleanApi().baseUrl}${EliteCleanApi().login}';

  //   // Fetch shared preferences instance to store user data
  //   final prefs = await SharedPreferences.getInstance();

  //   try {
  //     // Make the POST request to the login API with username and password
  //     var response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({
  //         "username": username,
  //         "password": password,
  //       }),
  //     );

  //     // Parse the response body
  //     var responseData = json.decode(response.body);
  //     print('Login API response: $responseData');

  //     // Handle different status codes
  //     switch (response.statusCode) {
  //       case 401:
  //         // Handle 401 Unauthorized
  //         print("Unauthorized (401) - Invalid username or password");
  //         loader.state = false;

  //       case 200:
  //         // If status code 200, login successful
  //         print("Login success - Access and refresh tokens received");

  //         // Extract tokens and expiry times from the API response
  //         final newAccessToken = responseData['tokens']['accessToken'];
  //         final newAccessTokenExpiryDate =
  //             DateTime.parse(responseData['tokens']['accessTokenExpiry']);
  //         final newRefreshToken = responseData['tokens']['refreshToken'];
  //         final newRefreshTokenExpiryDate =
  //             DateTime.parse(responseData['tokens']['refreshTokenExpiry']);

  //         print('New access token: $newAccessToken');

  //         // Update state using the copyWith method
  //         state = state.copyWith(
  //           tokens: state.tokens?.copyWith(
  //             accessToken: newAccessToken,
  //             refreshToken: newRefreshToken,
  //             accessTokenExpiry: newAccessTokenExpiryDate.toIso8601String(),
  //             refreshTokenExpiry: newRefreshTokenExpiryDate.toIso8601String(),
  //           ),
  //           user: state.user
  //               ?.copyWith(username: username), // Update username in state
  //         );

  //         print('Access token after login: ${state.tokens?.accessToken}');

  //         // Save updated user data to shared preferences
  //         final userData = json.encode({
  //           'username': username,
  //           'accessToken': newAccessToken,
  //           'accessTokenExpiry': newAccessTokenExpiryDate.toIso8601String(),
  //           'refreshToken': newRefreshToken,
  //           'refreshTokenExpiry': newRefreshTokenExpiryDate.toIso8601String(),
  //         });
  //         loader.state = false;
  //         await prefs.setString('userData', userData);
  //         print(
  //             "SharedPreferences updated with new token data: ${prefs.getString('userData')}");

  //       default:
  //         // Handle other status codes
  //         print("Unhandled status code: ${response.statusCode}");
  //     }
  //   } on FormatException catch (formatException) {
  //     print('Format Exception: ${formatException.message}');
  //     print('Invalid response format.');
  //   } on HttpException catch (httpException) {
  //     print('HTTP Exception: ${httpException.message}');
  //   } catch (e) {
  //     print('General Exception: ${e.toString()}');
  //     if (e is Error) {
  //       print('Stack Trace: ${e.stackTrace}');
  //     }
  //   }
  // }

  // php login
  Future<void> login(WidgetRef ref,
      {required String username, required String password}) async {
    print("Login API call started $username $password");

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
        'CONTENT_TYPE': 'application/json',
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
          break;

        case 200:
          print("Login success - Access and refresh tokens received");
          final authState = AuthState.fromJson(responseData);
          final newAccessToken = authState.data?.accessToken;
          final newAccessTokenExpiryDate =
              authState.data?.accessTokenExpiresAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      authState.data!.accessTokenExpiresAt! * 1000)
                  : null;
          final newRefreshToken = authState.data?.refreshToken;
          final newRefreshTokenExpiryDate =
              authState.data?.refreshTokenExpiresAt != null
                  ? DateTime.fromMillisecondsSinceEpoch(
                      authState.data!.refreshTokenExpiresAt! * 1000)
                  : null;

          // Update state and save to SharedPreferences
          state = state.copyWith(
            data: state.data?.copyWith(
              userId: authState.data?.userId,
              username: authState.data?.username,
              countryname: authState.data?.countryname,
              state: authState.data?.state,
              city: authState.data?.city,
              address: authState.data?.address,
              profilePic: authState.data?.profilePic,
              useRole: authState.data?.useRole,
              idFront: authState.data?.idFront,
              idBack: authState.data?.idBack,
              idCard: authState.data?.idCard,
              bankaccountno: authState.data?.bankaccountno,
              bankname: authState.data?.bankname,
              ifsccode: authState.data?.ifsccode,
              latitude: authState.data?.latitude,
              longitude: authState.data?.longitude,
              radius: authState.data?.radius,
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
          break;
      }
    } on FormatException catch (formatException) {
      print('Format Exception: ${formatException.message}');
      print('Invalid response format.');
    } on HttpException catch (httpException) {
      print('HTTP Exception: ${httpException.message}');
    } catch (e) {
      print('General Exception: ${e.toString()}');
      if (e is Error) {
        print('Stack Trace: ${e.stackTrace}');
      }
    } finally {
      loader.state = false;
    }
  }

  // Future<String> restoreAccessToken({String? call}) async {
  //   print("restore access started $call");
  //   final url =
  //       '${PurohitApi().baseUrl}${PurohitApi().login}/${state.sessionId}';

  //   final prefs = await SharedPreferences.getInstance();

  //   try {
  //     var response = await http.patch(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': state.accessToken!,
  //         'Content-Type': 'application/json; charset=UTF-8'
  //       },
  //       body: json.encode({"refresh_token": state.refreshToken}),
  //     );

  //     var userDetails = json.decode(response.body);
  //     print('restore token response $userDetails');
  //     switch (response.statusCode) {
  //       case 401:
  //         // Handle 401 Unauthorized
  //         // await logout();
  //         // await tryAutoLogin();
  //         print("shared preferance ${prefs.getString('userData')}");
  //         print('access token from restoreAccessToken:${state.accessToken}');
  //         break;
  //       case 200:
  //         print("refresh access token success");
  //         final newAccessToken = userDetails['data']['access_token'];
  //         final newAccessTokenExpiryDate = DateTime.now().add(
  //           Duration(seconds: userDetails['data']['access_token_expiry']),
  //         );
  //         final newRefreshToken = userDetails['data']['refresh_token'];
  //         final newRefreshTokenExpiryDate = DateTime.now().add(
  //           Duration(seconds: userDetails['data']['refresh_token_expiry']),
  //         );
  //         print('new accesstoken :$newAccessToken');
  //         // Update state
  //         state = state.copyWith(
  //           accessToken: newAccessToken,
  //           accessTokenExpiryDate: newAccessTokenExpiryDate,
  //           refreshToken: newRefreshToken,
  //           refreshTokenExpiryDate: newRefreshTokenExpiryDate,
  //         );
  //         print('access token from restoreAccessToken:${state.accessToken}');
  //         final userData = json.encode({
  //           'sessionId': state.sessionId,
  //           'refreshToken': newRefreshToken,
  //           'refreshExpiry': newRefreshTokenExpiryDate.toIso8601String(),
  //           'accessToken': newAccessToken,
  //           'accessTokenExpiry': newAccessTokenExpiryDate.toIso8601String(),
  //         });

  //         prefs.setString('userData', userData);
  //         print(
  //             "shared preferance after success  ${prefs.getString('userData')}");
  //       // loading(false); // Update loading state
  //     }
  //   } on FormatException catch (formatException) {
  //     print('Format Exception: ${formatException.message}');
  //     print('Invalid response format.');
  //   } on HttpException catch (httpException) {
  //     print('HTTP Exception: ${httpException.message}');
  //   } catch (e) {
  //     print('General Exception: ${e.toString()}');
  //     if (e is Error) {
  //       print('Stack Trace: ${e.stackTrace}');
  //     }
  //   }
  //   return state.accessToken!;
  // }

  // Future<void> logout() async {
  //   final url =
  //       '${PurohitApi().baseUrl}${PurohitApi().login}/${state.sessionId}';

  //   // Logout request to the server
  //   await http.delete(
  //     Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': state.accessToken!,
  //     },
  //   );

  //   // Cancel any running timers

  //   // Clear the shared preferences except for 'profile'
  //   final prefs = await SharedPreferences.getInstance();
  //   Set<String> keys = prefs.getKeys();
  //   for (String key in keys) {
  //     if (key != 'profile') {
  //       prefs.remove(key);
  //     }
  //   }

  //   // Reset the state to initial
  //   state = AuthState.initial();
  // }

  // Other methods...
}
// Other methods can be added here

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
