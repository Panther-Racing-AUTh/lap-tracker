
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/expenses_models/expense_item_model.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_provider.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
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
        title: Text('List Page'),
      ),
      body:ListView.builder(
        itemCount: expenseProvider.expenseList.length ,
        padding: EdgeInsets.symmetric(vertical: 2),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 2,horizontal: 3),
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.black26.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              title: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(expenseProvider.expenseList[index].name),
                        Text(convertDateTimeToString(expenseProvider.expenseList[index].dateTime))
                      ],
                    ),
                  ),
                  Spacer(),
                  Text('\$${double.parse(expenseProvider.expenseList[index].amount.toStringAsFixed(2))}')
                ],
              ),
            ),
          );
        },
      ),

    );
  }
}
