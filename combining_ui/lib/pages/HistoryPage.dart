import 'package:combining_ui/pages/CategoryPage.dart';
import 'package:combining_ui/pages/DetailPage.dart';
import 'package:combining_ui/pages/HomePage.dart';
import 'package:combining_ui/pages/ProfilePage.dart';
import 'package:combining_ui/utils/globals.dart';
//import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  final int userId;

  const HistoryPage({required this.userId});
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  
  String selectedMonth = "Apr";
  //int _selectedIndex = 2;
  //final Random _random = Random();
  final NumberFormat currencyFormat = NumberFormat("#,##0", "en_US");
  final Color themeColor = Color(0xFF1E3A8A);

  bool isLoading = false; 

  final List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final Map<String, Map<String, dynamic>> monthlyData = {};

  final List<Map<String, dynamic>> transactionTypes = [
    {"name": "Food"},
    {"name": "Medical"},
    {"name": "Travel"},
    {"name": "Tax"},
    {"name": "Game"},
    {"name": "Shopping"},
  ];

  @override
  void initState() {
    super.initState();
    fetchMonthlySummary();
  }

  void fetchMonthlySummary() async {
  setState(() {
    isLoading = true;
  });

    int monthIndex = months.indexOf(selectedMonth) + 1;
    int year = DateTime.now().year;
    String formattedMonth = "$year-${monthIndex.toString().padLeft(2, '0')}";

    final String url =
        '$baseURL/expense/monthly-summary?userId=${widget.userId}&month=$formattedMonth';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      setState(() {
        monthlyData[selectedMonth] = body['data']; // Backend sends MonthlySummaryDto
        isLoading = false;
      });
    } else {
      print('Error: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  } catch (e) {
    print('Exception while fetching summary: $e');
    setState(() {
      isLoading = false;
    });
  }

  }

  @override
  Widget build(BuildContext context) {


var data = monthlyData[selectedMonth] ?? {
  "goal": 0,
  "spent": 0,
  "saving": 0,
  "categories": []
};

List transactions = data["categories"] ?? [];


    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF074493),
          title: Center(
              child: Text(
            'History',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ))),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              children: months.map((month) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMonth = month;
                      fetchMonthlySummary();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedMonth == month ? themeColor : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: themeColor, width: 2),
                    ),
                    child: Text(
                      month,
                      style: TextStyle(
                        color:
                            selectedMonth == month ? Colors.white : themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Goal :",
                        style: TextStyle(
                            color: Color.fromARGB(255, 111, 113, 118),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Padding(padding: EdgeInsets.only(right: 68)),
                    Text(currencyFormat.format(data['goal']),
                        style: TextStyle(
                            fontSize: 16,
                            color: themeColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Spent :",
                        style: TextStyle(
                            color: Color.fromARGB(255, 111, 113, 118),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(currencyFormat.format(data['spent']),
                        style: TextStyle(
                            fontSize: 16,
                            color: themeColor,
                            fontWeight: FontWeight.bold)),
                    Text("Saving :",
                        style: TextStyle(
                            color: Color.fromARGB(255, 111, 113, 118),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    Text(currencyFormat.format(data['saving']),
                        style: TextStyle(
                            fontSize: 16,
                            color: themeColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return ListTile(
                  title: Text(transaction["name"]),
                  trailing: Text(
                    currencyFormat.format(
                      double.tryParse(transaction["amount"].toString())?.toInt() ?? 0 ),
                    style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          name: transaction["name"],
                          amount: transaction["amount"],
                          date: transaction["date"],
                          note: transaction["note"],
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF074493),
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 32,
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                        userId: widget.userId,
                      )),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(
                        userId: widget.userId,
                      )),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: widget.userId)),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
    );
  }
}
