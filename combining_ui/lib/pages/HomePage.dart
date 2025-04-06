import 'package:combining_ui/pages/CategoryPage.dart';
import 'package:combining_ui/pages/HistoryPage.dart';
import 'package:combining_ui/pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:combining_ui/utils/globals.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({required this.userId});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEditing = false; // Toggle edit mode
  OverlayEntry? _overlayEntry;
  String _amount = '10000.00';
  Map<String, dynamic>? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final url = Uri.parse('$baseURL/user/${widget.userId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          user = data;
          _amount = data['balance'].toString();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user: $e")),
      );
    }
  }

  Map<String, IconData> categoryIcons = {
    "Food": Icons.fastfood,
    "Shopping": Icons.shopping_bag,
    "Medical": Icons.medical_services,
    "Travel": Icons.airplanemode_active,
    "Tax": Icons.attach_money,
    "Game": Icons.sports_esports,
  };

  IconData _getCategoryIcon(String category) {
    return categoryIcons[category] ?? Icons.category;
  }

  List<String> categories = ["Food", "Shopping", "Medical", "Travel", "Tax"];

  void addCategory(String categoryName) {
    setState(() {
      categories.add(categoryName);
    });
  }

  void removeCategory(String categoryName) {
    setState(() {
      categories.remove(categoryName);
    });
  }

  void _openTransactionForm(String category) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionForm(
          category: category,
          userId: widget.userId,
        ),
      ),
    );

    if (result == true) {
      fetchUser(); // 👈 Reload the user and balance
    }
  }


  void _showOverlayEdit(BuildContext context) {
    final TextEditingController _amountController =
        TextEditingController(text: _amount);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          "Edit amount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Enter amount",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF074493),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () async {
                        final newBalance = _amountController.text.trim();

                        if (newBalance.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please enter a valid amount."),
                            ),
                          );
                          return;
                        }

                        try {
                          final url = Uri.parse(
                            '$baseURL/user/${widget.userId}/edit-balance?balance=$newBalance',
                          );

                          final response = await http.put(url);

                          if (response.statusCode == 200) {
                            setState(() {
                              _amount = newBalance; // Update UI
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text("Balance updated successfully.")),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "Failed to update balance: ${response.body}")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }

                        Navigator.of(dialogContext).pop(); // Close dialog
                      },
                      child: const Center(
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 280,
            height: 236,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Savings",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 25),
                Stack(
                  children: [
                    Container(
                      width: 179,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Color(0xFF074493),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Your savings",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_bitcoin_sharp,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '10,00.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white, // Icon color
                        size: 18,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xB39FC9FB),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.delete,
                        color: Colors.black, // Icon color
                        size: 18, // Icon size
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        _hideOverlay();
                      },
                      child: Container(
                        width: 128,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFF074493),
                        ),
                        child: Center(
                            child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    overlay?.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF074493),
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 32,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(
                        userId: widget.userId,
                      )),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HistoryPage(userId: widget.userId)),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    user != null ? "Hello ${user!['username']}" : "Hello",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => _showOverlay(context),
                    icon: const Icon(
                      Icons.savings,
                      size: 40,
                      color: Color(0xFF074493),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Color(0xFF074493),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Your available balance",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "฿ $_amount",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _showOverlayEdit(context),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Edit",
                    style: TextStyle(fontSize: 16, color: Color(0xFF074493)),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    icon: Icon(Icons.edit, color: Color(0xFF074493), size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: categories.length + 1, // +1 for "Customize"
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent:
                        100, // **Ensures consistent container height**
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    if (index < categories.length) {
                      String category = categories[index];
                      return GestureDetector(
                        onTap: () => _openTransactionForm(category),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topRight,
                          children: [
                            CategoryButton(
                              icon: _getCategoryIcon(category),
                              label: category,
                              onTap: () => _openTransactionForm(category),
                            ),
                            if (isEditing)
                              Positioned(
                                top: -5,
                                right: -5,
                                child: GestureDetector(
                                  onTap: () => removeCategory(category),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return CategoryButton(
                        icon: Icons.add,
                        label: "Customize",
                        onTap: () async {
                          final newCategory = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomizeScreen()),
                          );
                          if (newCategory != null) {
                            addCategory(newCategory);
                          }
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryButton(
      {Key? key, required this.icon, required this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: double.infinity, // **Ensures full width**
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12), // **Consistent padding**
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Color(0xFF074493)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class CustomizeScreen extends StatefulWidget {
  @override
  _CustomizeScreenState createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF074493),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Customize", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Category name",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    Navigator.pop(context, _controller.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Color(0xFF074493),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text("Confirm",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionForm extends StatefulWidget {
  final String category;
  final int userId;

  TransactionForm({required this.category, required this.userId});


  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }


Future<void> _submitTransaction() async {
  if (!_formKey.currentState!.validate()) return;

  final amount = double.tryParse(_amountController.text);
  if (amount == null || amount <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a valid amount")),
    );
    return;
  }

int _getCategoryId(String category) {
  switch (category.toLowerCase()) {
    case "food":
      return 1;
    case "shopping":
      return 2;
    case "medical":
      return 3;
      case "travel":
      return 4;
    case "Tax":
      return 5;
    case "Customize":
      return 6;
    default:
      return 0; // or throw
  }
}


  final expenseData = {
    "userId": widget.userId,
    "categoryId": _getCategoryId(widget.category), // ✅ Fix this
    "amount": amount,
    "description": _noteController.text,
    "date": _dateController.text, // Must be in yyyy-MM-dd format
  };

  final url = Uri.parse('$baseURL/expense/add');
  print('Sending to $url with data: $expenseData'); // Debug log


  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(expenseData),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 && decoded["success"] == true) {
      final newBalance = decoded["data"]["newBalance"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transaction saved! New balance: $newBalance")),
      );
      Navigator.of(context).pop(true); // Go back after saving
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${decoded["message"]}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Network error: $e")),
    );
  }
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'Add Transaction - ${widget.category}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xE6074493),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 30),
        child: Form(
          key: _formKey,
          child: Container(
            width: 250,
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    Icon(Icons.fastfood_outlined),
                    SizedBox(width: 20),
                    Text(
                      widget.category,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Text("Amount", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter amount",
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please enter an amount" : null,
                ),
                SizedBox(height: 16),
                Text("Date", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Select a date",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => selectDate(context),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please select a date" : null,
                ),
                SizedBox(height: 16),
                Text("Note", style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter a description",
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xE6074493),
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: _submitTransaction,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 20),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancel"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}