import 'dart:io';
import 'package:clean/cleaner/API/Edit_Profile_Api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final ProfileApiService _apiService = ProfileApiService();

  File? _image;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  int maxTravelDistance = 13;
  String preferredWorkingHours = "9to5";

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _submitProfileUpdate() async {
    // Validate inputs
    if (fullNameController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Full Name and Email are required')),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Update profile image if selected
      if (_image != null) {
        await _apiService.updateProfileImage(_image!);
      }

      // Update personal information
      await _apiService.updatePersonalInfo(
        fullName: fullNameController.text,
        email: emailController.text,
        location: locationController.text,
        phoneNumber: phoneController.text,
        bio: bioController.text,
      );

      // Update service preferences
      await _apiService.updateServicePreferences(
        maxTravelDistance: maxTravelDistance,
        preferredWorkingHours: preferredWorkingHours,
      );

      // Close loading indicator
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      // Close loading indicator
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  void handleChange(String field, dynamic value) {
    setState(() {
      if (field == 'maxTravelDistance') {
        maxTravelDistance = value;
      } else if (field == 'preferredWorkingHours') {
        preferredWorkingHours = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color with transparency
                  blurRadius: 10.0, // How soft the shadow is
                  spreadRadius: 2.0, // How far the shadow spreads
                  offset: Offset(0, 5), // Position of the shadow (x, y)
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildProfileSection(),
                  const SizedBox(height: 20),
                  _buildInputField('Full Name', TextInputType.text,
                      controller: fullNameController),
                  const SizedBox(height: 20),
                  _buildInputField('Email', TextInputType.emailAddress),
                  const SizedBox(height: 20),
                  _buildInputField('Location', TextInputType.text,
                      controller: locationController),
                  const SizedBox(height: 20),
                  _buildInputField('Phone Number', TextInputType.phone,
                      controller: phoneController),
                  const SizedBox(height: 20),
                  _buildInputField('Bio', TextInputType.multiline,
                      controller: bioController, maxLines: 3),
                  const SizedBox(height: 20),
                  const Text(
                    "Service Preferences",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildServicePreferences(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: const Color.fromARGB(255, 236, 235,
                              235), // Set the text color of the Cancel button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Set the padding
                        ),
                        onPressed: () {
                          // Add your cancel button logic here
                          // For example, you can navigate back to the previous screen
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                          width: 16.0), // Add some spacing between the buttons
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors
                              .black, // Set the text color of the Save button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Set the border radius
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12), // Set the padding
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildProfileSection() {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _showImagePickerOptions();
            },
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(Icons.add_a_photo, size: 30, color: Colors.white)
                  : null,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(6.0),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextInputType keyboardType,
      {TextEditingController? controller, int maxLines = 1}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }

  Widget _buildServicePreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.work),
            SizedBox(width: 8),
            Text('Maximum Travel Distance (Km)',
                style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: maxTravelDistance.toDouble(),
          min: 1,
          max: 50,
          divisions: 49,
          activeColor: Colors.black,
          label: "$maxTravelDistance Km",
          onChanged: (value) =>
              handleChange('maxTravelDistance', value.toInt()),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.timer),
            SizedBox(width: 8),
            Text('Preferred Working Hours', style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double
              .infinity, // This makes the width match the text input fields
          child: Container(
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  5), // Matching the input field border radius
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              // Remove the default underline
              child: DropdownButton<String>(
                isExpanded: true, // This ensures the dropdown takes full width
                value: preferredWorkingHours,
                onChanged: (value) =>
                    handleChange('preferredWorkingHours', value!),
                items: const [
                  DropdownMenuItem(value: "9to5", child: Text("9 AM - 5 PM")),
                  DropdownMenuItem(value: "8to4", child: Text("8 AM - 4 PM")),
                  DropdownMenuItem(value: "10to6", child: Text("10 AM - 6 PM")),
                  DropdownMenuItem(value: "flexible", child: Text("Flexible")),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
