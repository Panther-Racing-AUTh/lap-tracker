import 'dart:math';


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/date_time_helper.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/form_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/list_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:provider/provider.dart';

class BarChartExample extends StatefulWidget {
  const BarChartExample({super.key});

  @override
  State<BarChartExample> createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  TextEditingController nameEditor=TextEditingController(text: '');
  TextEditingController amountEditor=TextEditingController();
  bool isSaveable=false;

  double totalAmount=0;
  double maxY=500;
  List<ExpenseItem> expensitem=[
    ExpenseItem(name: 'training', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 1)), location: "none",category: "Engine"),
    ExpenseItem(name: 'shopping', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 2)), location: "none",category: "Engine"),
    ExpenseItem(name: 'training', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 3)), location: "none",category: "Engine"),
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
    if (formattedAmount.endsWith('00')) {
      // Replace ".00" with "00"
      formattedAmount = formattedAmount.replaceAll('00', '00');
    } else if (formattedAmount.endsWith('0')) {
      // Replace single trailing zero with double zeros
      formattedAmount = formattedAmount.replaceAll('0', '');
      formattedAmount += '0';
    }

    return formattedAmount;
  }


  @override
  Widget build(BuildContext context) {
    final ExpenseItemProvider expenseItemProvider=Provider.of<ExpenseItemProvider>(context,listen: false);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text('Total Amount:  ',style: TextStyle(fontSize: 18),),
                    ),
                    Container(
                      child: Text('\$${double.parse(totalAmount.toStringAsFixed(2))}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),

                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*.02,
                ),
                Container(
                  height: MediaQuery.of(context).size.height *.3,
                  child: BarChart(
                    BarChartData(
                      groupsSpace: 20,
                      alignment: BarChartAlignment.center,
                      maxY: maxY,
                      minY: 0,
                      borderData: FlBorderData(
                        show: false,
                      ),
                      baselineY: 10,
                      titlesData: FlTitlesData(
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false,),),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(getTitlesWidget: getBottomTitles,showTitles: true))
                      ),
                      gridData: FlGridData(show: false),
                      barGroups: List.generate(
                        expenseItemProvider.listAmount.length,
                            (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              color: Colors.grey.shade800,
                              toY: double.parse(expenseItemProvider.listAmount[index].toStringAsFixed(2)),
                              width: 10*2.5,
                              borderRadius: BorderRadius.circular(4),
                              backDrawRodData: BackgroundBarChartRodData(
                                color: Colors.white.withOpacity(0.8),
                                toY: maxY,
                                show: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*.02,
                ),
                Container(
                  child: Column(
                    children: [
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
                              expenseItemProvider.expenseList.length<4 ? expenseItemProvider.expenseList.length : 4,
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
                                              Text(expenseItemProvider.expenseList[index].name),
                                              Text(convertDateTimeToString(expenseItemProvider.expenseList[index].dateTime))
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Text('+\$${formatAmount(expenseItemProvider.expenseList[index].amount)}')
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
                maxY=getMaxY(expenseItemProvider.listAmount,maxY);
                totalAmount=getTotalAmount(expenseItemProvider.listAmount);
                await Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(index: 0,),));
                expenseItemProvider.getAllAmountList();
                maxY=getMaxY(expenseItemProvider.listAmount,maxY);

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
