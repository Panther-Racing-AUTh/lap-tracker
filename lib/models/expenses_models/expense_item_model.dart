import 'package:flutter/material.dart';

class ExpenseItem{
  final String name;
  final double amount;
  final DateTime dateTime;
  final String expenseType;
  final String location;
  final bool isExpense;

  ExpenseItem({
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.expenseType,
    required this.location,
    required this.isExpense
  });
}

String convertDateTimeToString(DateTime dateTime){
  String year=dateTime.year.toString();
  String month=dateTime.month.toString();
  if(month.length==1){
    month='0' + month;
  }
  String day=dateTime.day.toString();
  if(day.length==1){
    day='0' + day;
  }
  String yyyymmdd='${year}/${month}/${day}';
  return yyyymmdd;
}


String convertAmountTostring(double amount){

  return amount.toString();
}


// Assuming this widget is part of a StatefulWidget or StatelessWidget
class YourExpenseListWidget extends StatelessWidget {
  final List<ExpenseItem> expenseList; // Assuming you have a list of ExpenseItem

  YourExpenseListWidget({required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (context, index) {
        return buildExpenseListItem(index);
      },
    );
  }

  Widget buildExpenseListItem(int index) {
    ExpenseItem expenseItem = expenseList[index];

    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: expenseItem.isExpense ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expenseItem.name),
                  Text(convertDateTimeToString(expenseItem.dateTime)),
                ],
              ),
            ),
            Spacer(),
            Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expenseItem.isExpense ? '-\$${convertAmountToString(expenseItem.amount)}' : '+\$${convertAmountToString(expenseItem.amount)}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on, size: 11, color: Colors.grey.shade700),
                      Text(
                        expenseItem.location,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convertDateTimeToString(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
  }

  String convertAmountToString(double amount) {
    return amount.toStringAsFixed(2);
  }
}
