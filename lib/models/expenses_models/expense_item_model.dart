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
