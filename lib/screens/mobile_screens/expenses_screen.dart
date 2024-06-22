
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/drawer_model.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/about_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:flutter_complete_guide/widgets/expenses_widgets/account/multi_account_widget.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/form_page.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
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
            signOut(context);

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

      }
    });
  }


  @override
  Widget build(BuildContext context) {
    final ExpenseItemProvider expenseProvider=Provider.of<ExpenseItemProvider>(context,listen: false);
    final ExpenseAccountProvider expenseAccountProvider=Provider.of<ExpenseAccountProvider>(context,listen: false);

    return ChangeNotifierProvider(create: (context) => ExpenseAccountProvider(),builder: (context, child) => Scaffold(


      body: Scaffold(
        appBar: AppBar(

          title: Text(expenses),
          actions: [
            GestureDetector(
                onTap: () {
                  _showAccountPopupMenu(context, DrawerIndexValue.chat.getInt());
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
        drawer: DrawerModel(context,DrawerIndexValue.chat.getInt()),

        body: Stack(
          children: [
            Container(
              color: Colors.grey.shade300,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height,
                      child: MultiExpenseAccountWidget(expenseAccounts: expenseAccountProvider.expenseAccountList)
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*.02,
                  ),
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
                  final ExpenseAccountProvider expenseAccountProvider =Provider.of<ExpenseAccountProvider>(context,listen: false);
                  print('Floating Action Button pressed!');
                  maxY=getMaxY(expenseProvider.listAmount,maxY);
                  totalAmount=getTotalAmount(expenseProvider.listAmount);
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => FormPage(index: expenseAccountProvider.currentIndex,),));
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
