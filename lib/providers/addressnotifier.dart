import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/addressstate.dart';

class AddressNotifier extends StateNotifier<AddressState> {
  AddressNotifier() : super(AddressState());

  // Method to fetch suggestions from Nominatim API
  Future<void> fetchAddressSuggestions(String input) async {
    print('adress : $input');
    if (input.isEmpty) return;
    const String baseUrl = 'https://nominatim.openstreetmap.org/search';
    final Uri url =
        Uri.parse('$baseUrl?q=$input&format=json&addressdetails=1&limit=5');

    try {
      final http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> suggestions = json.decode(response.body);
        state = state.copyWith(suggestions: suggestions);
      } else {
        throw Exception('Failed to load suggestions');
      }
    } catch (e) {
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
