import 'package:flutter/material.dart';

class IconColorPage extends StatefulWidget {
  final String currentColor;
  final Function(String) onColorSelected;

  IconColorPage({required this.currentColor, required this.onColorSelected});

  @override
  _IconColorPageState createState() => _IconColorPageState();
}

class _IconColorPageState extends State<IconColorPage> {
  late String selectedColor;

  final List<Map<String, dynamic>> colors = [
    {"name": "Blue", "color": Colors.blue},
    {"name": "Pink", "color": Colors.pink},
    {"name": "Green", "color": Colors.green},
    {"name": "Yellow", "color": Colors.yellow},
    {"name": "Grey", "color": Colors.grey},
    {"name": "Purple", "color": Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    selectedColor = widget.currentColor;
  }

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
            Navigator.pop(context, selectedColor); // Return selected color
          },
        ),
        title: const Text(
          "Icon color",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: colors.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final color = colors[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color["name"];
                });
                widget.onColorSelected(color["name"]);
              },
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: color["color"],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "FinFocus",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        color["name"],
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedColor == color["name"])
                        const Icon(Icons.check, color: Colors.blue, size: 20),
                    ],
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
