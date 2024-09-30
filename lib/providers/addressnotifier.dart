import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/addressstate.dart';

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState());

  // Method to fetch suggestions from Nominatim API
  Future<void> fetchAddressSuggestions(String input) async {
    print('Address input: $input');

    if (input.isEmpty) return;

    // Base URL for the Nominatim API
    const String baseUrl = 'https://nominatim.openstreetmap.org/search';

    // Build the full URL with query input and country restriction to India
    final url = Uri.parse(
        '$baseUrl?q=$input&countrycodes=in&format=json&addressdetails=1');

    try {
      // Make the GET request to Nominatim API
      final http.Response response = await http.get(url);

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> suggestions = json.decode(response.body);

        // Update the state with the fetched suggestions
        state = state.copyWith(suggestions: suggestions);
      } else {
        // Throw an exception if the status code is not 200
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
      // Print error message if any exception occurs
      print('Error fetching suggestions: $e');
    }
  }

  void clearSuggestions() {
    state = state.copyWith(suggestions: []);
  }

  // Method to select an address from suggestions
  void selectAddress(dynamic suggestion) {
    final latitude = double.parse(suggestion['lat']);
    final longitude = double.parse(suggestion['lon']);
    final selectedAddress = suggestion['display_name'];

    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      selectedAddress: selectedAddress,
      suggestions: [], // Clear suggestions after selection
    );
  }
}

// Riverpod provider for AddressNotifier
final addressProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  return AddressNotifier();
});
