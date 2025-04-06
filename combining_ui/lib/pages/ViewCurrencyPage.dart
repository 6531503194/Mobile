import 'package:flutter/material.dart';
import 'package:combining_ui/pages/CurrencyDetailPage.dart';

class ViewCurrencyPage extends StatelessWidget {
  final Color primaryColor = const Color(0xFF074493);

  final List<Map<String, dynamic>> currencyRates = [
    {"flag": "🇺🇸", "name": "USD", "todayRate": 33.79, "yesterdayRate": 35.66},
    {"flag": "🇯🇵", "name": "JPY", "todayRate": 34.92, "yesterdayRate": 36.10},
    {"flag": "🇬🇧", "name": "GBP", "todayRate": 41.76, "yesterdayRate": 42.50},
    {"flag": "🇨🇳", "name": "CNY", "todayRate": 4.69, "yesterdayRate": 4.88},
    {"flag": "🇧🇷", "name": "PES", "todayRate": 0.58, "yesterdayRate": 0.60},
    {"flag": "🇦🇺", "name": "AUD", "todayRate": 20.91, "yesterdayRate": 21.15},
    {"flag": "🇨🇦", "name": "CAD", "todayRate": 23.18, "yesterdayRate": 23.55},
    {"flag": "🇨🇺", "name": "CUB", "todayRate": 1.41, "yesterdayRate": 1.45},
    {"flag": "🇰🇷", "name": "SKW", "todayRate": 0.58, "yesterdayRate": 0.60},
  ];

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
          "Currency",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today Currency Rate",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Date: 4 April, 2025",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: currencyRates.length,
                itemBuilder: (context, index) {
                  final currency = currencyRates[index];
                  return buildCurrencyItem(
                    context,
                    currency["flag"],
                    currency["name"],
                    currency["todayRate"],
                    currency["yesterdayRate"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrencyItem(BuildContext context, String flag, String name,
      double todayRate, double yesterdayRate) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CurrencyDetailPage(
              flag: flag,
              currencyName: name,
              todayRate: todayRate,
              yesterdayRate: yesterdayRate,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(flag, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "฿ ${todayRate.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey.shade700),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
