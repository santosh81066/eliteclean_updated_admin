import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/addressstate.dart';
import '../providers/addressnotifier.dart';

class CleanerRegistration extends ConsumerStatefulWidget {
  const CleanerRegistration({super.key});

  @override
  _CleanerRegistrationState createState() => _CleanerRegistrationState();
}

class _CleanerRegistrationState extends ConsumerState<CleanerRegistration> {
  late TextEditingController _addressController;
  TextEditingController _countryController =
      TextEditingController(text: 'India'); // Set default country
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  TextEditingController radius = TextEditingController();
  TextEditingController mobileno = TextEditingController();
  late ScrollController _scrollController;
  Timer? _debounce;

  final _formKey = GlobalKey<FormState>(); // Global key for form validation

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _countryController =
        TextEditingController(text: 'India'); // Set default country
    _stateController = TextEditingController();
    _cityController = TextEditingController();
    _scrollController = ScrollController();

    // Fetch countries when initializing the form
    ref.read(addressProvider.notifier).loadJsonData().then((_) {
      ref
          .read(addressProvider.notifier)
          .filterStates(); // Filter for Indian states
    });
  }

  @override
  void dispose() {
    _addressController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _scrollController.dispose();
    mobileno.dispose();
    radius.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Scroll to the address text field
  void _scrollToAddressField() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent + 300,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Debounce method to wait before fetching address suggestions
  void _onAddressChanged(String input, AddressNotifier addressNotifier) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (input.isEmpty) {
        addressNotifier
            .clearSuggestions(); // Clear suggestions if the input is empty
      } else {
        addressNotifier.fetchAddressSuggestions(
            input); // Fetch suggestions if input is not empty
      }
    });
  }

  // Validate all form fields
  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // If all validations pass, proceed with the form submission
      print('Form is valid, proceeding with submission...');
      Navigator.pushNamed(context, '/userprofile');
    } else {
      print('Form is not valid, fix the errors.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressProvider);
    final addressNotifier = ref.read(addressProvider.notifier);

    if (addressState.suggestions.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToAddressField(); // Ensure scrolling happens after the widget has rendered
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context)
              .unfocus(); // Close the keyboard when tapping outside
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Form(
              key: _formKey, // Form key to validate the form fields
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  SvgPicture.asset(
                    'assets/images/logo-icon.svg',
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E116B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Please enter your details to sign up and create an account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF77779D)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: const Color(0xFFEAE9FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextFormField(
                          controller: mobileno,
                          label: 'Mobile number',
                          hintText: 'Enter your Mobile no',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Mobile no';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextFormField(
                            label: 'Country',
                            controller: _countryController,
                            readonly: true),
                        const SizedBox(height: 20),
                        _buildStateDropdown(addressNotifier, addressState),
                        const SizedBox(height: 20),
                        _buildCityDropdown(addressNotifier, addressState),
                        const SizedBox(height: 20),
                        _buildAddressField(
                          addressController: _addressController,
                          addressNotifier: addressNotifier,
                          addressState: addressState,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 5),
                        _buildTextFormField(
                            controller: radius,
                            label: 'radius',
                            hintText: 'Enter radius',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter radius';
                              }
                              return null;
                            })
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 320,
                    child: ElevatedButton(
                      onPressed:
                          _validateAndSubmit, // Validate and submit the form
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF583EF2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateDropdown(
      AddressNotifier addressNotifier, AddressState addressState) {
    return Row(
      children: [
        Icon(Icons.map, color: const Color(0xFFB8B8D2)),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'State'),
            value: addressState.selectedState,
            items: addressState.states
                .map((state) => DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    ))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                addressNotifier.filterCities(value);
                _stateController.text = value;
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCityDropdown(
      AddressNotifier addressNotifier, AddressState addressState) {
    return Row(
      children: [
        Icon(Icons.location_city, color: const Color(0xFFB8B8D2)),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'City'),
            value: addressState.selectedCity,
            items: addressState.cities
                .map((city) => DropdownMenuItem(
                      value: city,
                      child: Text(city),
                    ))
                .toList(),
            onChanged: (value) {
              _cityController.text = value!;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField(
      {required String label,
      String? hintText,
      IconData? icon,
      bool? readonly,
      String? Function(String?)?
          validator, // Validator function for field validation
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F1F39),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, color: const Color(0xFFB8B8D2)),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: controller,
                readOnly: readonly ?? false,
                keyboardType: TextInputType.text,
                validator: validator, // Validation logic
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  hintStyle: const TextStyle(color: Color(0xFFB8B8D2)),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildAddressField({
    required TextEditingController addressController,
    required AddressNotifier addressNotifier,
    required AddressState addressState,
    required String? Function(String?) validator, // Validation for address
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F1F39),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Color(0xFFB8B8D2)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressController,
                    validator: validator, // Address validation
                    onChanged: (input) {
                      _onAddressChanged(
                          input, addressNotifier); // Debounced text change
                    },
                    decoration: const InputDecoration(
                      hintText: 'your address here',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFB8B8D2)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
        if (addressState.suggestions.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: addressState.suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = addressState.suggestions[index];
                return ListTile(
                  title: Text(suggestion['description']),
                  onTap: () {
                    addressController.text = suggestion['description'];
                    addressNotifier.selectAddress(suggestion['place_id']);
                    addressNotifier.clearSuggestions();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
