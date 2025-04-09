import 'package:combining_ui/pages/SignInPage.dart';
import 'package:flutter/material.dart';
import 'package:combining_ui/pages/CategoryPage.dart';
import 'package:combining_ui/pages/HistoryPage.dart';
import 'package:combining_ui/pages/HomePage.dart';
import 'package:combining_ui/pages/MoreSettingPage.dart';
import 'package:combining_ui/pages/ViewCurrencyPage.dart';
import 'package:combining_ui/pages/PremiumPage.dart';
import 'package:combining_ui/pages/FAQPage.dart';
import 'package:combining_ui/pages/ContactUsPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:combining_ui/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart'; // for baseURL

class ProfilePage extends StatefulWidget {
  final int userId;

  const ProfilePage({required this.userId});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Color primaryColor = const Color(0xFF074493);
  Map<String, dynamic>? user;

  String _nickname = 'Set Your Nickname';
  String _avatarImage = 'assets/images/Avatar.png';

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
          _nickname = data['nickname'] ??
              "No nickname"; // 👈 optional, if needed elsewhere
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        iconSize: 32,
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(userId: widget.userId)));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryPage(userId: widget.userId)));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HistoryPage(userId: widget.userId)));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.widgets), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 60),

          // **Title "My Profile" with Crown Icon for Premium**
          Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: const Text(
                  "My Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Positioned(
                top: 10,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PremiumPage()),
                    );
                  },
                  child: Icon(Icons.workspace_premium,
                      color: Colors.white, size: 28), // Premium icon only
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // **Profile Avatar**
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // CircleAvatar(
              //   radius: 40,
              //   backgroundColor: Colors.white,
              //   child: const Icon(Icons.person, size: 40, color: Colors.grey),
              // ),
              Container(
                width: 110, // 2 * radius
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, // Background color
                ),
                child: ClipOval(
                  child: Image.asset(
                    _avatarImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return _buildEditProfileDialog(context,
                              (newNickname) {
                            setState(() {
                              _nickname = newNickname;
                            });
                          });
                        },
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child:
                          Icon(Icons.edit, color: Color(0xFF074493), size: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // **User Name**
          Text(
            user != null ? "${user!['username']}" : "",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // **Profile Options (Updated with FAQ and Contact Us)**
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  buildProfileButton(Icons.attach_money, "View Currency",
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewCurrencyPage()),
                    );
                  }),
                  buildProfileButton(Icons.settings, "More Setting", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MoreSettingPage()),
                    );
                  }),
                  buildProfileButton(Icons.phone, "Contact Us", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()),
                    );
                  }),
                  buildProfileButton(Icons.question_answer_sharp, "FAQ",
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQPage()),
                    );
                  }),
                  buildProfileButton(Icons.logout_rounded, "Log out",
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('userId'); // or prefs.clear() if you want everything gone

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                          (route) => false, // remove all previous routes
                        );
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileButton(IconData icon, String label,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: primaryColor),
              const SizedBox(width: 15),
              Text(
                label,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileDialog(
      BuildContext context, Function(String) onNicknameChanged) {
    final TextEditingController _nicknameController =
        TextEditingController(text: _nickname);

    String tempAvatar = _avatarImage; // local copy to preview inside dialog

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setLocalState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 👤 Avatar preview (dynamic)
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      tempAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 👨‍🦱 👩‍🦱 Male & Female avatar choices
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.male,
                          color: Color(0xFF074493), size: 36),
                      onPressed: () {
                        setLocalState(() {
                          tempAvatar = 'assets/images/Boy profile.png';
                        });
                      },
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.female,
                          color: Color(0xFF074493), size: 36),
                      onPressed: () {
                        setLocalState(() {
                          tempAvatar = 'assets/images/Girl profile.png';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ✅ Confirm button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF074493),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      onNicknameChanged(_nicknameController.text);
                      setState(() {
                        _avatarImage = tempAvatar;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text("Confirm",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
