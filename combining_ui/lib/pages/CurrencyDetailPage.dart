import 'package:flutter/material.dart';

class CurrencyDetailPage extends StatelessWidget {
  final String flag;
  final String currencyName;
  final double todayRate;
  final double yesterdayRate;

  const CurrencyDetailPage({
    Key? key,
    required this.flag,
    required this.currencyName,
    required this.todayRate,
    required this.yesterdayRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF074493);

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
          "Currency Detail",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Currency Flag
            Text(flag, style: const TextStyle(fontSize: 50)),

            const SizedBox(height: 8),

            // Currency Name
            Text(
              currencyName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // Exchange Rate Boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCurrencyBox(
                    "Yesterday Currency", "03/04/2025", yesterdayRate),
                const SizedBox(width: 10),
                buildCurrencyBox("Today Currency", "04/04/2025", todayRate),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildCurrencyBox(String title, String date, double rate) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              date,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "฿ ${rate.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
