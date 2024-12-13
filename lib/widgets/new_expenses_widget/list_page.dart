import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/date_time_helper.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  final int index;

  ListPage({
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final expenseAccountProvider =
    Provider.of<ExpenseAccountProvider>(context, listen: false);

    final List<ExpenseItem> expenseList =
        expenseAccountProvider.expenseAccountList[index].expenseList;

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.close),
        ),
        title: Text('Expense List'),
      ),
      body: ListView.builder(
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          ExpenseItem expenseItem = expenseList[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              tileColor: expenseItem.amount < 0 ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: expenseItem.amount < 0 ? Colors.red : Colors.green,
                child: Icon(
                  expenseItem.amount < 0 ? Icons.arrow_circle_down : Icons.arrow_circle_up,
                  color: Colors.white,
                ),
              ),
              title: Text(
                expenseItem.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                convertDateTimeToString(expenseItem.dateTime),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              trailing: Text(
                expenseItem.amount < 0 ? '-\$${formatAmount(expenseItem.amount)}' : '+\$${formatAmount(expenseItem.amount)}',
                style: TextStyle(
                  color: expenseItem.amount < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String formatAmount(double amount) {
    String formattedAmount = amount.toStringAsFixed(2);
    if(amount < 0){
      if (formattedAmount.length > 1) {
        return formattedAmount.substring(1); // Return substring from index 1 to end
      } else {
        return ''; // Return empty string for input of length 0 or 1
      }
    }
    return formattedAmount.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match match) => '${match[1]},',
    );
  }
}
