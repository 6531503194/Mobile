import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  final Color primaryColor = const Color(0xFF074493);
  String selectedPlan = "300 Baht/month"; // Default selected plan

  final List<Map<String, String>> plans = [
    {"title": "300 Baht/month", "subtitle": "Monthly subscription"},
    {"title": "1000 Baht/year", "subtitle": "Yearly subscription"},
    {"title": "2500 Baht/one time", "subtitle": "Lifetime subscription"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // **Curved Header Section**
            Stack(
              alignment: Alignment.topLeft,
              children: [
                // **Curved Blue Background**
                ClipPath(
                  clipper: _CustomCurveClipper(),
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    color: primaryColor,
                  ),
                ),

                // **Back Button**
                Positioned(
                  top: 40,
                  left: 15,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),

                // **Crown Icon & Title**
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      const Icon(Icons.workspace_premium,
                          color: Colors.amber, size: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Start Your Free\n7 day trial",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // **Premium Plans Label**
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Premium Plans",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // **Subscription Plan Options**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: plans.map((plan) {
                  return buildPlanOption(
                    title: plan["title"]!,
                    subtitle: plan["subtitle"]!,
                    isSelected: selectedPlan == plan["title"],
                    onTap: () {
                      setState(() {
                        selectedPlan = plan["title"]!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // **Buy Now Button**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                onPressed: () {
                  // Handle Buy Now action
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: primaryColor, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                  "Buy now",
                  style: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // **Start Free Trial Button**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  // Handle Start Free Trial action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Start Free Trial",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildPlanOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isSelected ? Colors.white70 : Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// **Custom Curved Header**
class _CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
