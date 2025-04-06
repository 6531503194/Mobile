import 'package:flutter/material.dart';

class DarkModePage extends StatefulWidget {
  final String currentMode;
  final Function(String) onModeSelected;

  DarkModePage({required this.currentMode, required this.onModeSelected});

  @override
  _DarkModePageState createState() => _DarkModePageState();
}

class _DarkModePageState extends State<DarkModePage> {
  late String selectedMode;

  @override
  void initState() {
    super.initState();
    selectedMode = widget.currentMode;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF074493);
    final bool isDarkMode = selectedMode == "On";

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, selectedMode); // Pass selected mode back
          },
        ),
        title: const Text(
          "Dark Mode",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildDarkModeOption("On", isDarkMode),
            buildDarkModeOption("Off", isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget buildDarkModeOption(String mode, bool isDarkMode) {
    final Color primaryColor = const Color(0xFF074493);
    final bool isSelected = selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = mode;
        });
        widget.onModeSelected(mode); // Notify parent
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mode,
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isSelected) Icon(Icons.check, color: primaryColor, size: 24),
          ],
        ),
      ),
    );
  }
}
