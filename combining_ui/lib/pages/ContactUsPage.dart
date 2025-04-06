import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF074493);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Contact Us", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Keep in Touch",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            const Text(
              "If you have any inquiries, keep in touch with us.\nWe’ll be happy to help you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),

            // **Phone Contact**
            buildContactCard(Icons.phone, "+66 123 456 789"),
            buildContactCard(Icons.email, "finfocus@gmail.com"),

            const SizedBox(height: 20),

            // **Social Media Section**
            const Text(
              "Social Media",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            buildSocialMediaButton(Icons.facebook,
                "Stay updated, connect and engage with us on Facebook."),
            buildSocialMediaButton(Icons.camera,
                "Explore our world and discover updates at our Instagram."),
            buildSocialMediaButton(Icons.chat,
                "Join the conversation, stay informed, and connect with us on Twitter. Follow us now!"),
          ],
        ),
      ),
    );
  }

  Widget buildContactCard(IconData icon, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryColor),
          const SizedBox(width: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSocialMediaButton(IconData icon, String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
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
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
