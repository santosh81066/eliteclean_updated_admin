import 'package:image_picker/image_picker.dart';

class ImageModel {
  final XFile? frontImage;
  final XFile? backImage;
  final XFile? profileImage; // New field for profile image

  ImageModel({this.frontImage, this.backImage, this.profileImage});
}
