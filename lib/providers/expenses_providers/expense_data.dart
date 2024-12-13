import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_account.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';

class ExpenseItemProvider with ChangeNotifier{
  List<ExpenseItem> expenseList=[];
  List<double> listAmount=[0,0,0,0,0,0,0];



  List<ExpenseItem> getAllExpenseList(){
    return expenseList;
  }

  void addNewExpense(ExpenseItem newExpense){
    expenseList.add(newExpense);
    notifyListeners();
  }

  void removeExpense(ExpenseItem selectedItem){
    expenseList.remove(selectedItem);
    notifyListeners();
  }


  void getAllAmountList(){
    listAmount=[0,0,0,0,0,0,0];

    for(ExpenseItem item in expenseList){
      switch(item.dateTime.weekday){
        case 1:
          listAmount[0]+=item.amount;
          break;
        case 2:
          listAmount[1]+=item.amount;
          break;
        case 3:
          listAmount[2]+=item.amount;
          break;
        case 4:
          listAmount[3]+=item.amount;
          break;
        case 5:
          listAmount[4]+=item.amount;
          break;
        case 6:
          listAmount[5]+=item.amount;
          break;
        case 7:
          listAmount[6]+=item.amount;
          break;
        default:
          break;
      }
    }


  }



}

class ExpenseAccountProvider with ChangeNotifier{
  List<ExpenseAccount> expenseAccountList=[
    ExpenseAccount(
      id: generateAccountNumber(),
      name: 'Total Amount',
      amount: 2500.0,
      expenseList: [
        ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),
        ExpenseItem(
          name: 'Transportation',
          amount: 150.0,
          dateTime: DateTime.now().subtract(Duration(days: 2)),
          location: 'Gas Station',

          category: "",
        ),
        ExpenseItem(
          name: 'Utilities',
          amount: 200.0,
          dateTime: DateTime.now().subtract(Duration(days: 5)),
          location: 'Utility Company',

          category: "",
        ),
      ],
    ),
    ExpenseAccount(
      id: generateAccountNumber(),
      name: '100 x 100',
      amount: 2500.0,
      expenseList: [
        ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),
        ExpenseItem(
          name: 'Transportation',
          amount: 150.0,
          dateTime: DateTime.now().subtract(Duration(days: 2)),
          location: 'Gas Station',

          category: "",
        ),
        ExpenseItem(
          name: 'Utilities',
          amount: 200.0,
          dateTime: DateTime.now().subtract(Duration(days: 5)),
          location: 'Utility Company',

          category: "",
        ),
      ],
    ),
    ExpenseAccount(
      id: generateAccountNumber(),
      name: 'Sponshorships',
      amount: 2500.0,
      expenseList: [
        ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),ExpenseItem(
          name: 'Groceries',
          category: "",
          amount: 100.0,
          dateTime: DateTime.now(),
          location: 'Supermarket',
        ),
        ExpenseItem(
          name: 'Transportation',
          amount: 150.0,
          dateTime: DateTime.now().subtract(Duration(days: 2)),
          location: 'Gas Station',

          category: "",
        ),
        ExpenseItem(
          name: 'Utilities',
          amount: 200.0,
          dateTime: DateTime.now().subtract(Duration(days: 5)),
          location: 'Utility Company',

          category: "",
        ),
      ],
    )
  ];

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int newIndex) {
    _currentIndex = newIndex;
    notifyListeners(); // Notify listeners of state change
  }



  List<ExpenseAccount> getAllExpenseAccountList(){
    return expenseAccountList;
  }

  void addNewAccountExpense(ExpenseAccount newAccountExpense){
    expenseAccountList.add(newAccountExpense);
    notifyListeners();
  }

  void removeExpense(ExpenseAccount selectedAccountExpense){
    expenseAccountList.remove(selectedAccountExpense);
    notifyListeners();
  }




}
String generateAccountNumber() {
  // Generate a random 10-digit account number
  Random random = Random();
  String prefix = 'PR';
  String suffix = '';
  for (int i = 0; i < 12; i++) {
    if(i%4==0){
      suffix += ' ';
    }
    suffix += random.nextInt(10).toString();

  }
  return '$prefix$suffix';
}
