import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileApiService {
  final String baseUrl = 'https://your-api-endpoint.com/api';

  // Method to update profile image
  Future<bool> updateProfileImage(File imageFile) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/profile/image'));

      // Add the image file to the request
      request.files.add(
          await http.MultipartFile.fromPath('profile_image', imageFile.path));

      // Add any necessary headers (e.g., authentication token)
      // request.headers['Authorization'] = 'Bearer your_token_here';

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Image upload failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }

  // Method to update personal information
  Future<bool> updatePersonalInfo({
    required String fullName,
    required String email,
    String? location,
    String? phoneNumber,
    String? bio,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile/personal-info'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer your_token_here'
        },
        body: jsonEncode({
          'full_name': fullName,
          'email': email,
          'location': location,
          'phone_number': phoneNumber,
          'bio': bio,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Personal info update failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating personal info: $e');
      return false;
    }
  }

  // Method to update service preferences
  Future<bool> updateServicePreferences({
    required int maxTravelDistance,
    required String preferredWorkingHours,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/profile/service-preferences'),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer your_token_here'
        },
        body: jsonEncode({
          'max_travel_distance': maxTravelDistance,
          'preferred_working_hours': preferredWorkingHours,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Service preferences update failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating service preferences: $e');
      return false;
    }
  }
}
