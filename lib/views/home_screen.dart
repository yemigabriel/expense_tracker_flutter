import 'package:expense_tracker/views/add_expense.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showBottomSheet(context);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20.0,
          children: [
            Center(
              child: Image.asset(
                'assets/images/empty.png',
                width: MediaQuery.of(context).size.width / 1.5,
                fit: BoxFit.fitWidth,
              ),
            ),
            Center(
              child: Text(
                "No expenses yet",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  showBottomSheet(context);
                },
                icon: Icon(Icons.add),
                label: Text("Add your first expense"),
                style: ElevatedButton.styleFrom(
                  // textStyle: Theme.of(context).textTheme.labelLarge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    builder: (context) {
      return SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Add expenses manually"),
                onTap: () => addExpense(context),
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Scan receipt"),
              ),
              ListTile(
                leading: Icon(Icons.corporate_fare),
                title: Text("Connect to bank account"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void addExpense(BuildContext context) {
  Navigator.pop(context);
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (context) => AddExpense()));
}
