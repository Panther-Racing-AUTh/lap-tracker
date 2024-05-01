
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/expenses_models/expense_item_model.dart';

class ExpenseData with ChangeNotifier{
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

  String getDayName(DateTime dateTime){
    switch(dateTime.weekday){
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }
  DateTime startOfWeekDate(){
    DateTime? startOfWeek;

    DateTime today =DateTime.now();
    for(int i=0;i<7;i++){
      if(getDayName(today.subtract(Duration(days: i)))=='Sun'){
        startOfWeek =today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }


}
