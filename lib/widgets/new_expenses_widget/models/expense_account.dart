import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';

class ExpenseAccount {
  final String id;
  final String name;
  double amount;
  final List<ExpenseItem> expenseList;

  ExpenseAccount({
    required this.id,
    required this.name,
    required this.amount,
    required this.expenseList,
  });




}


class ExpenseItemWidget extends StatelessWidget {
  final ExpenseItem  expenseItem;

  ExpenseItemWidget({required this.expenseItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name: ${expenseItem.name}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'Amount: \$${expenseItem.amount.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'Date: ${expenseItem.dateTime.toString()}',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'Location: ${expenseItem.location}',
            style: TextStyle(fontSize: 14),
          ),
          Divider(),
        ],
      ),
    );
  }
}
