import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF074493);

  final List<Map<String, String>> faqList = [
    {
      "question": "Why is there no account/login for this app?",
      "answer":
          "To protect user privacy, we use Apple iCloud service to sync data between devices, so there is no need to register an account."
    },
    {
      "question": "Why does the app data not sync among my devices?",
      "answer":
          "In order to make cloud sync work, you need to make sure:\n1. In your iPhone’s Setting app - Apple ID - iCloud setting - iCloud Drive function is enabled.\n2. iCloud permission for this app is allowed.\n3. Your iCloud storage is not full.\nIf it still does not work, try to turn off cloud sync then turn it on again."
    },
    {
      "question": "Why can’t I find the Budget app’s widgets?",
      "answer":
          "If you cannot see our app’s widgets in the list, reboot your iPhone and try again."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("FAQ", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqList.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${index + 1}. ${faqList[index]["question"]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    faqList[index]["answer"]!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
