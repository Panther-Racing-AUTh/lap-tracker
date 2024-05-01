import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_provider.dart';
import 'package:flutter_complete_guide/models/expenses_models/expense_item_model.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameEditor = TextEditingController();
  final TextEditingController amountEditor = TextEditingController();
  bool isSaveable = false;

  @override
  Widget build(BuildContext context) {
    final ExpenseData expenseProvider=Provider.of<ExpenseData>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        title: Text('Form Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Enter Name',
                ),
                onChanged: (value) {
                  setState(() {
                    isSaveable = nameEditor.text.isNotEmpty && amountEditor.text.isNotEmpty;
                  });
                },
                controller: nameEditor,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                      ),
                      controller: amountEditor,
                      onChanged: (value) {
                        setState(() {
                          isSaveable = nameEditor.text.isNotEmpty && amountEditor.text.isNotEmpty;
                        });
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Text('  \$', style: TextStyle(fontSize: 18),),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSaveable ? () {
                  // Save button logic goes here
                  print('Name: ${nameEditor.text}');
                  print('Amount: ${amountEditor.text}');
                  ExpenseItem tempExpenseItem=ExpenseItem(name: nameEditor.text, amount: parseDouble(amountEditor.text), dateTime: DateTime.now(), location: 'Niaou',expenseType: "Engineering",isExpense: false);
                  expenseProvider.addNewExpense(tempExpenseItem);
                  Navigator.pop(context); // Pop the current page
                  setState(() {

                  });
                } : null,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  double parseDouble(String digitsString) {
    try {
      // Use double.parse to convert the digitsString to a double value
      double result = double.parse(digitsString);
      return result;
    } catch (e) {
      // Handle any parsing errors (e.g., invalid format)
      print('Error parsing double value: $e');
      return 0.0; // Return a default value (or handle error as needed)
    }
  }
}
