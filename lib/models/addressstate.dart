class AddressState {
  final List<dynamic> suggestions;
  final double? latitude;
  final double? longitude;
  final String? selectedAddress;

  AddressState({
    this.suggestions = const [],
    this.latitude,
    this.longitude,
    this.selectedAddress,
  });

  AddressState copyWith({
    List<dynamic>? suggestions,
    double? latitude,
    double? longitude,
    String? selectedAddress,
  }) {
    return AddressState(
      suggestions: suggestions ?? this.suggestions,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}
