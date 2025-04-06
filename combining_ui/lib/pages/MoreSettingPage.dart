import 'package:flutter/material.dart';
import 'package:combining_ui/pages/DarkModePage.dart';
import 'package:combining_ui/pages/IconColorPage.dart';

class MoreSettingPage extends StatefulWidget {
  @override
  _MoreSettingPageState createState() => _MoreSettingPageState();
}

class _MoreSettingPageState extends State<MoreSettingPage> {
  final Color primaryColor = const Color(0xFF074493);
  bool isNotificationOn = true;
  String darkModeStatus = "Off";
  String iconColor = "Blue"; // Default icon color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "More Setting",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildSettingOption(
              "Notification",
              Icons.notifications,
              trailing: Switch(
                value: isNotificationOn,
                onChanged: (value) {
                  setState(() {
                    isNotificationOn = value;
                  });
                },
                activeColor: primaryColor,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DarkModePage(
                      currentMode: darkModeStatus,
                      onModeSelected: (mode) {
                        setState(() {
                          darkModeStatus = mode;
                        });
                      },
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    darkModeStatus = result;
                  });
                }
              },
              child: buildSettingOption(
                "Dark Mode",
                Icons.nightlight_round,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(darkModeStatus,
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IconColorPage(
                      currentColor: iconColor,
                      onColorSelected: (color) {
                        setState(() {
                          iconColor = color;
                        });
                      },
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    iconColor = result;
                  });
                }
              },
              child: buildSettingOption(
                "Icon color",
                Icons.color_lens,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(iconColor,
                        style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
            buildSettingOption(
              "Rating our app",
              Icons.star,
              trailing: const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingOption(String title, IconData icon, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}
