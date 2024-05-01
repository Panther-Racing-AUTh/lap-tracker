import 'dart:math';


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_provider.dart';
import 'package:flutter_complete_guide/models/expenses_models/expense_item_model.dart';
import 'package:flutter_complete_guide/widgets/expenses_widgets/form_widget.dart';
import 'package:flutter_complete_guide/widgets/expenses_widgets/list_widget.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:provider/provider.dart';

  class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  TextEditingController nameEditor=TextEditingController(text: '');
  TextEditingController amountEditor=TextEditingController();
  bool isSaveable=false;

  double totalAmount=0;
  double maxY=500;
  List<ExpenseItem> expensitem=[
    ExpenseItem(name: 'training', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 1)), location: "none",expenseType: 'Engineering',isExpense: false),
    ExpenseItem(name: 'shopping', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 2)), location: "none",expenseType: 'Engineering',isExpense: true),
    ExpenseItem(name: 'training', amount: Random().nextDouble()*100, dateTime: DateTime.now().add(Duration(days: 3)), location: "none",expenseType: 'Engineering',isExpense: false),
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
    final ExpenseData expenseProvider=Provider.of<ExpenseData>(context,listen: false);
    if(expenseProvider.expenseList.isEmpty){
      expenseProvider.expenseList.addAll(expensitem);
    }
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
  void _showAccountPopupMenu(BuildContext context,int viewIndex) {

    late bool getBool;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero);
    final double buttonWidth = button.size.width;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double dx = screenWidth ;
    final double dy = 100;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(dx, dy, dx, dy),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      items: [
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
            setState(() {

            });
            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));
            }
          },
          child: Row(

            children: [
              Icon(Icons.account_circle),
              SizedBox(width: 10,),
              Text('Profile')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
            setState(() {

            });

            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));
            }          },
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 10,),
              Text('Settings')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
            setState(() {

            });

            if(viewIndex==DrawerIndexValue.home.getInt()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen(),));
            }else{
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutScreen(),));
            }            },
          child: Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: 10,),
              Text('About')
            ],
          ),

        ),
        PopupMenuItem<String>(

          value: 'Option 1',
          onTap: () {
            setState(() {
              signOut(context);
            });
          },
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 10,),
              Text('Logout`')
            ],
          ),

        ),

      ],
    ).then((value) {
      if (value != null) {
        setState(() {

        });
      }
    });
  }

  String formatDoubleWithTwoDecimals(double value) {
    // Convert the double value to a string with two decimal places
    String formattedValue = value.toStringAsFixed(2);

    // Check if the formatted value has exactly two decimal places
    if (formattedValue.contains('.') && formattedValue.split('.')[1].length == 1) {
      // Add a trailing zero to the formatted value (e.g., "12.5" becomes "12.50")
      formattedValue += '0';
    }

    return formattedValue;
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseData expenseProvider=Provider.of<ExpenseData>(context,listen: false);
    return ChangeNotifierProvider(create: (context) => ExpenseData(),builder: (context, child) => Scaffold(
      appBar: AppBar(
        title: Text(expenses),
        actions: [
          GestureDetector(
              onTap: () {
                _showAccountPopupMenu(context, DrawerIndexValue.expenses.getInt());
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Image.asset('assets/panther_logo_transparent.png',errorBuilder: (context, error, stackTrace) => Icon(Icons.account_circle,size: 40,),),
              )
          )
        ],
      ),
      drawer: DrawerModel(context,DrawerIndexValue.expenses.getInt()),

      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade300,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*.02,
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
                  height: MediaQuery.of(context).size.height*.03,
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
                      titlesData: FlTitlesData(
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(sideTitles: SideTitles(getTitlesWidget: getBottomTitles,showTitles: true))
                      ),
                      gridData: FlGridData(show: false),
                      barGroups: List.generate(
                        expenseProvider.listAmount.length,
                            (index) => BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              color: Colors.grey.shade800,
                              toY: double.parse(expenseProvider.listAmount[index].toStringAsFixed(2)),
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(),));
                                  setState(() {

                                  });
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
                              expenseProvider.expenseList.length< 4 ? expenseProvider.expenseList.length : 4,
                                  (index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: expenseProvider.expenseList[index].isExpense ? Colors.orange.withOpacity(0.1): Colors.green.withOpacity(0.1)

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
                                        Container(
                                          width: 100,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              expenseProvider.expenseList[index].isExpense ? Text('-\$${double.parse(expenseProvider.expenseList[index].amount.toStringAsFixed(2))}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,)) : Text('+\$${double.parse(expenseProvider.expenseList[index].amount.toStringAsFixed(2))}',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.location_on,size: 11,color: Colors.grey.shade700,),
                                                  Text('${expenseProvider.expenseList[index].location}',style: TextStyle(fontSize: 11,color: Colors.grey.shade600),),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
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
                await Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(),));
                setState(() {
                  expenseProvider.getAllAmountList();
                  totalAmount=getTotalAmount(expenseProvider.listAmount);
                });
              },
              child: Icon(Icons.add), // You can change the icon as needed
            ),
          ),
        ],
      ),
    ),);
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
