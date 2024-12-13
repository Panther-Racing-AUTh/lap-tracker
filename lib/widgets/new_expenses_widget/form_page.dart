import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:provider/provider.dart';

enum Accounts {
  total_amount,
  _100x100,
  sponsorship,
  parts,
}

extension AccountExtension on Accounts {
  String get displayName {
    switch (this) {
      case Accounts.total_amount:
        return 'Total Amount';
      case Accounts._100x100:
        return '100 x 100';
      case Accounts.sponsorship:
        return 'Sponsorships';
      case Accounts.parts:
        return 'Parts';
      default:
        return '';
    }
  }
}

class FormPage extends StatefulWidget {
  final int index;

  FormPage({
    required this.index,
  });

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  bool isSaveable = false;
  Accounts _selectedCategory = Accounts.total_amount;
  Accounts _selectedPriority = Accounts.total_amount; // New dropdown

  @override
  Widget build(BuildContext context) {
    final ExpenseItemProvider expenseItemProvider =Provider.of<ExpenseItemProvider>(context, listen: false);
    final ExpenseAccountProvider expenseAccountProvider =Provider.of<ExpenseAccountProvider>(context, listen: false);


    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        title: Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: 'Expense Name',
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isSaveable = nameController.text.isNotEmpty &&
                          amountController.text.isNotEmpty;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: 'Amount (\$)',
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    setState(() {
                      isSaveable = nameController.text.isNotEmpty &&
                          amountController.text.isNotEmpty;
                    });
                  },
                ),
                SizedBox(height: 24),
                DropdownButtonFormField<Accounts>(
                  value: _selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: Accounts.values.map((account) {
                    return DropdownMenuItem<Accounts>(
                      value: account,
                      child: Text(account.displayName),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<Accounts>(
                  value: _selectedPriority, // New dropdown value
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '',
                    labelStyle: TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: Accounts.values.map((account) {
                    return DropdownMenuItem<Accounts>(
                      value: account,
                      child: Text(account.displayName),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSaveable
                      ? () {
                    double amount =
                        double.tryParse(amountController.text) ?? 0.0;
                    // Create ExpenseItem based on selected values
                    ExpenseItem expenseItem = ExpenseItem(
                      name: nameController.text,
                      amount: amount,
                      dateTime: DateTime.now(),
                      location: '',
                      category: _selectedCategory.displayName,
                    );
                    expenseAccountProvider.expenseAccountList[widget.index].expenseList.add(expenseItem);
                    Navigator.pop(context);
                  }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isSaveable ? Colors.blue : Colors.grey,
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 16),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  child: Text(
                    'Save Expense',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
