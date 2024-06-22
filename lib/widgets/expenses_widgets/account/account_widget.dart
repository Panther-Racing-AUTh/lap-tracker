
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_account.dart';




class ExpenseAccountWidget extends StatefulWidget {
  final ExpenseAccount expenseAccount;



  ExpenseAccountWidget({required this.expenseAccount});

  @override
  State<ExpenseAccountWidget> createState() => _ExpenseAccountWidgetState();
}

class _ExpenseAccountWidgetState extends State<ExpenseAccountWidget> {
  double totalAmount=0;


  @override
  void initState(){
    totalAmount=getAmount();

  }

  double getAmount(){
    double tempAmount=0;
    for(int i=0;i<widget.expenseAccount.expenseList.length;i++){
      tempAmount+=widget.expenseAccount.expenseList[i].amount;
      print(tempAmount);
    }
    return tempAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(3, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  print("niaou");
                },
                child: SizedBox(
                  width: 150,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expenseAccount.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          "\$ ${formatAmount(totalAmount)}",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Spacer(),
              Container(
                alignment: Alignment.center,
                width: 30,
                child: GestureDetector(
                  onTap: () {
                    print('object');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                    child: Icon(Icons.more_vert),
                  ),
                ),
              ),

            ],
          ),
          Spacer(),
          Text(
            "${widget.expenseAccount.id}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,

            ),
          ),
          Spacer(),
          Row(
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_circle_down_rounded, size: 25,),
                        Text(
                          " Income",
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        " \$ ${formatAmount(widget.expenseAccount.amount)}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),


              Spacer(),
              Container(
                width: 150,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.arrow_circle_up_rounded, size: 25),
                          Text(
                            " Income",
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      " \$ ${formatAmount(widget.expenseAccount.amount)}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),

            ],
          ),

        ],
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
