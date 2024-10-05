import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../models/id_cards.dart';

class ImageNotifier extends StateNotifier<ImageModel> {
  ImageNotifier() : super(ImageModel());

  final picker = ImagePicker();

  // Pick front image
  Future<void> pickFrontImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = ImageModel(
        frontImage: XFile(pickedFile.path),
        backImage: state.backImage,
        profileImage: state.profileImage,
      );
    }
  }

  // Pick back image
  Future<void> pickBackImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = ImageModel(
        frontImage: state.frontImage,
        backImage: XFile(pickedFile.path),
        profileImage: state.profileImage,
      );
    }
  }

  // Pick profile image
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = ImageModel(
        frontImage: state.frontImage,
        backImage: state.backImage,
        profileImage: XFile(pickedFile.path), // Set profile image
      );
    }
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, ImageModel>(
  (ref) => ImageNotifier(),
);
