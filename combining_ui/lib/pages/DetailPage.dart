import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String categoryName;
  final List<Map<String, dynamic>> expenses;

  const DetailPage({
    required this.categoryName,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details - $categoryName",
          style: TextStyle(color: Colors.white), 
        ),
        backgroundColor: Color(0xFF1E3A8A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: expenses.isEmpty
                  ? Center(child: Text("No expenses for this category"))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow("Date", expense["date"] ?? "Unknown"),
                                _buildDetailRow("Amount", "\$${expense["amount"] ?? 0}"),
                                _buildDetailRow("Note", expense["description"] ?? "No note"),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        width: 250,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(Icons.close,
                                    color: Colors.black, size: 24),
                              ),
                            ),
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 50),
                            SizedBox(height: 10),
                            Text("Done!",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text(
                              "Detail is already saved in your gallery",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Text("Save Detail in Gallery",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }
}
