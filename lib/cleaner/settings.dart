import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Spanish'];
  Map<String, dynamic> settings = {
    'notifications': true,
    'emailNotifications': true,
    'darkMode': false,
    'language': 'english',
    'notificationTypes': {
      'newJobs': true,
      'jobReminders': true,
      'payments': true,
      'promotions': false,
    },
    'notificationFrequency': 'immediate',
  };

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? settingsString = prefs.getString('user-settings');
    if (settingsString != null) {
      setState(() {
        settings = jsonDecode(settingsString);
      });
    }
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user-settings', jsonEncode(settings));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 62, 180, 137).withOpacity(0.1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Settings",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Notifications",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildSwitchRow(
                    icon: Icons.notifications,
                    text: "Push Notifications",
                    value: settings["notifications"],
                    onChanged: (value) {
                      setState(() {
                        settings["notifications"] = value;
                      });
                      saveSettings();
                    },
                  ),
                  const SizedBox(height: 5),
                  buildSwitchRow(
                    icon: Icons.email,
                    text: "Email Notifications",
                    value: settings["emailNotifications"],
                    onChanged: (value) {
                      setState(() {
                        settings["emailNotifications"] = value;
                      });
                      saveSettings();
                    },
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Appearance",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            settings['darkMode']
                                ? Icons.nightlight_round
                                : Icons.wb_sunny,
                            color: settings['darkMode']
                                ? Colors.black
                                : Colors.black,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Dark Mode",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: settings["darkMode"],
                        onChanged: (value) {
                          setState(() {
                            settings["darkMode"] = value;
                          });
                          saveSettings();
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.black,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade400,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Language",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.language_rounded),
                      const SizedBox(width: 2),
                      const Text(
                        "Language",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 1), // Reduced vertical padding
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(6), // Smaller border radius
                      border: Border.all(color: Colors.grey),
                    ),
                    child: DropdownButton<String>(
                      value: selectedLanguage,
                      icon: const Icon(Icons.arrow_drop_down,
                          size: 20), // Smaller icon
                      underline: const SizedBox(), // Removed default underline
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14), // Reduced font size
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedLanguage = newValue!;
                        });
                      },
                      isExpanded: true,
                      items: languages
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                                fontSize: 14), // Adjust font size of items
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Security",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              6), // Match container's border radius
                        ),
                      ),
                      onPressed: () {
                        // Your logic for changing the password
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock, // Lock icon
                            size: 18,
                            color: Colors.black, // Set color to black
                          ),
                          const SizedBox(
                              width: 8), // Space between icon and text
                          const Text(
                            "Change Password",
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black // Normal weight
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Help & Support",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'mohlomimahlomola@gmail.com',
                          query:
                              'subject=Support Request&body=Describe your issue here.',
                        );

                        if (kIsWeb) {
                          // Use launchUrl for web compatibility
                          if (await launchUrl(emailUri,
                              mode: LaunchMode.externalApplication)) {
                            // Successfully opened email client
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Could not open email client.')),
                            );
                          }
                        } else {
                          // For mobile platforms
                          if (await canLaunchUrl(emailUri)) {
                            await launchUrl(emailUri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Could not open email client.')),
                            );
                          }
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.support_agent,
                            size: 18,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Contact Support",
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                          saveSettings();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitchRow({
    required IconData icon,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.black,
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade400,
        ),
      ],
    );
  }
}
