import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:combining_ui/utils/globals.dart';

import 'HistoryPage.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

class CategoryPage extends StatefulWidget {
  final int userId;

  const CategoryPage({required this.userId});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final Color primaryColor = const Color(0xFF074493); // Theme Color
  bool _isLoading = true;
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = Uri.parse('$baseURL/expense/${widget.userId}/category-summary'); 

    try {
      final response = await http.get(url);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded["success"] == true) {
        final List fetched = decoded["data"];
        setState(() {
          categories = fetched.map((item) {
            return {
              "icon": _getCategoryIcon(item["categoryName"]),
              "label": item["categoryName"],
              "amount": item["totalAmount"]
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to fetch categories: ${decoded["message"]}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading categories: $e")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case "food":
        return Icons.fastfood;
      case "shopping":
        return Icons.shopping_bag;
      case "medical":
        return Icons.medical_services;
      case "travel":
        return Icons.airplanemode_active;
      case "tax":
        return Icons.attach_money;
      case "game":
        return Icons.sports_esports;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 32,
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HistoryPage(userId: widget.userId)),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: statusBarHeight + 65,
                      color: primaryColor,
                    ),
                    Positioned(
                      top: statusBarHeight + 10,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          "Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: categories.isEmpty
                      ? const Center(child: Text("No expenses found."))
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 0),
                          itemCount: categories.length,
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.grey[300], thickness: 1);
                          },
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(category["icon"], color: primaryColor, size: 28),
                                      const SizedBox(width: 15),
                                      Text(
                                        category["label"],
                                        style: const TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "฿ ${category["amount"].toStringAsFixed(2)}",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
