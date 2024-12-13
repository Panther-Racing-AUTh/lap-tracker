import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/chart_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/date_time_helper.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/form_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/list_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameEditor=TextEditingController(text: '');
  TextEditingController amountEditor=TextEditingController();
  bool isSaveable=false;

  double totalAmount=0;
  double maxY=500;


  String _selectedItem = 'Option 1';
  List<String> _dropdownItems = ['Option 1', 'Option 2', 'Option 3'];

  List<ExpenseItem> expensitem=[
    ExpenseItem(name: 'training', amount: math.Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 1)), location: "none",category: "Engine"),
    ExpenseItem(name: 'shopping', amount: math.Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 2)), location: "none",category: "Engine"),
    ExpenseItem(name: 'training', amount: math.Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 3)), location: "none",category: "Engine"),
  ];

  double getTotalAmount(List<double> amountList){
    double temp=0;
    for(int i=0;i<amountList.length;i++){
      temp+=amountList[i];
    }
    return temp;
  }

  double getMaxY(List<double> amountList,double maxY){
    double max=maxY;
    for(int i=0;i<amountList.length;i++){
      if(max<amountList[i]){
        int temp=((amountList[i])/100).floor();
        max=temp * 100 + 100;
      }
    }
    print(max);
    return max;
  }

  @override
  void initState(){
    final ExpenseItemProvider expenseProvider=Provider.of<ExpenseItemProvider>(context,listen: false);
    expenseProvider.expenseList.addAll(expensitem);
    expenseProvider.getAllAmountList();
    maxY=getMaxY(expenseProvider.listAmount,maxY);
    totalAmount=getTotalAmount(expenseProvider.listAmount);
    nameEditor.addListener(_updateButtonState);
    amountEditor.addListener(_updateButtonState);

    setState(() {

    });
  }


  @override
  void dispose() {
    amountEditor.dispose();
    nameEditor.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      isSaveable = amountEditor.text.isNotEmpty && nameEditor.text!='';
    });
  }
  String formatAmount(double amount) {
    // Convert the double amount to a string with fixed two decimal places
    String formattedAmount = amount.toStringAsFixed(2);

    // Check if the formatted amount ends with ".00" (no decimal places)
    if (formattedAmount.endsWith('.00')) {
      // Replace ".00" with "00"
      formattedAmount = formattedAmount.replaceAll('00', '00');
    } else if (formattedAmount.endsWith('0')) {
      // Replace single trailing zero with double zeros
      formattedAmount = formattedAmount.replaceAll('0', '');
      formattedAmount += '0';
    }



    // Split the formatted amount into integer and decimal parts
    List<String> parts = formattedAmount.split('.');
    String integerPart = parts[0];
    String decimalPart = (parts.length > 1) ? '.' + parts[1] : '';

    // Format the integer part with thousands separators
    String formattedIntegerPart = '';
    int length = integerPart.length;
    for (int i = 0; i < length; i++) {
      formattedIntegerPart += integerPart[length - 1 - i]; // Append digits from end to start
      if ((i + 1) % 3 == 0 && i != length - 1) {
        formattedIntegerPart += ','; // Add comma every three digits (except at the end)
      }
    }

    // Reverse the formatted integer part to correct the order
    formattedIntegerPart = formattedIntegerPart.split('').reversed.join();

    // Combine formatted integer part with decimal part
    formattedAmount = formattedIntegerPart + decimalPart;

    return formattedAmount;
  }




  @override
  Widget build(BuildContext context) {
    final ExpenseItemProvider expenseProvider=Provider.of<ExpenseItemProvider>(context,listen: false);
    final ExpenseAccountProvider expenseAccountProvider=Provider.of<ExpenseAccountProvider>(context,listen: false);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade300,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*.08,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*.02,
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 400,
                        child: TradingLineChart(
                            data: [
                              TradingData(date : DateTime(2022, 4, 1),price:  45000),
                              TradingData(date :DateTime(2022, 4, 2),price:   48000),
                              TradingData(date :DateTime(2022, 4, 3),price:   47000),
                              TradingData(date :DateTime(2022, 4, 4),price:   49000),
                              TradingData(date :DateTime(2022, 4, 5),price:   48500),
                              TradingData(date :DateTime(2022, 4, 6),price:   50000),
                              TradingData(date :DateTime(2022, 4, 7),price:   52000),
                              TradingData(date :DateTime(2022, 4, 8),price:   53000),
                              TradingData(date :DateTime(2022, 4, 9),price:   52500),
                              TradingData(date :DateTime(2022, 4, 10),price:   51000),
                              TradingData(date :DateTime(2022, 4, 11),price:   50500),
                              TradingData(date :DateTime(2022, 4, 12),price:   52000),
                              TradingData(date :DateTime(2022, 4, 13),price:   51500),
                              TradingData(date :DateTime(2022, 4, 14),price:   51000),
                              TradingData(date :DateTime(2022, 4, 15),price:   52500),
                              TradingData(date :DateTime(2022, 4, 16),price:   53000),
                              TradingData(date :DateTime(2022, 4, 17),price:   53500),
                              TradingData(date :DateTime(2022, 4, 18),price:   54000),
                              TradingData(date :DateTime(2022, 4, 19),price:   54500),
                              TradingData(date :DateTime(2022, 4, 20),price:   55000),
                            ]
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 0),
                        child: Row(
                          children: [
                            Spacer(),
                            MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(index: 0,),));
                                },
                                child: Text('See all')
                            ),
                          ],
                        ),
                      ),
                      Container(

                          height: MediaQuery.of(context).size.height * .47 ,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white70
                          ),
                          child: Column(
                            children: List.generate(
                              expenseProvider.expenseList.length<4 ? expenseProvider.expenseList.length : 4,
                                  (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.green.withOpacity(0.2)
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
                                        Text('+\$${formatAmount(expenseProvider.expenseList[index].amount)}')
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /*

           */
          Positioned(
            bottom: 16.0, // Adjust the bottom offset as needed
            right: 16.0, // Adjust the right offset as needed
            child: FloatingActionButton(
              onPressed: () async{
                print('Floating Action Button pressed!');
                maxY=getMaxY(expenseProvider.listAmount,maxY);
                totalAmount=getTotalAmount(expenseProvider.listAmount);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(index: 0,)));
                expenseProvider.getAllAmountList();
                maxY=getMaxY(expenseProvider.listAmount,maxY);
                totalAmount=getTotalAmount(expenseProvider.listAmount);

                setState(() {

                });
              },
              child: Icon(Icons.add), // You can change the icon as needed
            ),
          ),
        ],
      ),
    );
  }

  Color getBarColor(double amount){
    if(amount>maxY){
      return Colors.red.shade800;
    }else if(amount<=maxY && amount>maxY * 3/4){
      return Colors.orange.shade800;
    }else if(amount<=maxY* 3/4 && amount>maxY/2){
      return Colors.yellow.shade800;
    }else if(amount<=maxY/2 && amount>maxY/5){
      return Colors.grey.shade400;
    }else{
      return Colors.grey.shade800;
    }
  }


  Widget getBottomTitles(double value,TitleMeta meta){
    DateTime dateTime=DateTime.now();
    TextStyle style=TextStyle(
      color:dateTime.weekday-1==value ? Colors.purple: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: dateTime.weekday-1==value ? 13: 12,
    );

    Widget? text;
    switch (value.toInt()){
      case 0:
        text=  Text('M',style: style,);
        break;
      case 1:
        text=  Text('T',style: style,);
        break;
      case 2:
        text=  Text('W',style: style,);
        break;
      case 3:
        text=  Text('T',style: style,);
        break;
      case 4:
        text=  Text('F',style: style,);
        break;
      case 5:
        text=  Text('S',style: style,);
        break;
      case 6:
        text=  Text('S',style: style,);
        break;
      default:
        text=  Text('',style: style,);
        break;

    }
    return SideTitleWidget(child: text, axisSide: meta.axisSide);

  }
}
