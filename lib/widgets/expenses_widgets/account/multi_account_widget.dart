
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/expenses_widgets/account/account_widget.dart';
import 'package:flutter_complete_guide/widgets/expenses_widgets/item/item_widget.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/list_page.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_account.dart';
import 'package:flutter_complete_guide/providers/expenses_providers/expense_data.dart';
import 'package:provider/provider.dart';

class MultiExpenseAccountWidget extends StatefulWidget {
  final List<ExpenseAccount> expenseAccounts;

  MultiExpenseAccountWidget({required this.expenseAccounts});

  @override
  _MultiExpenseAccountWidgetState createState() => _MultiExpenseAccountWidgetState();
}

class _MultiExpenseAccountWidgetState extends State<MultiExpenseAccountWidget> {
  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    final ExpenseAccountProvider expenseAccountProvider =Provider.of<ExpenseAccountProvider>(context,listen: false);
    expenseAccountProvider.updateIndex(0);
    _pageController = PageController(initialPage: expenseAccountProvider.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseAccountProvider expenseAccountProvider =Provider.of<ExpenseAccountProvider>(context,listen: false);

    return Container(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.expenseAccounts.length,
              onPageChanged: (index) {
                setState(() {
                  expenseAccountProvider.updateIndex(index);
                });
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeInOut.transform(value) * MediaQuery.of(context).size.height * 0.3,
                        child: child,
                      ),
                    );
                  },
                  child: ExpenseAccountWidget(expenseAccount: widget.expenseAccounts[index]),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.expenseAccounts.length,
                  (index) => buildIndicator(index, 8),
            ),
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPage(index: expenseAccountProvider.currentIndex,),));
                            setState(() {

                            });
                          },
                          child: Text('See all')
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(

                      height: MediaQuery.of(context).size.height * .47 ,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white70
                      ),
                      child: ExpenseListWidget(expenseList: widget.expenseAccounts[expenseAccountProvider.currentIndex].expenseList),



                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget buildIndicator(int index, double initialSize) {
    final ExpenseAccountProvider expenseAccountProvider =Provider.of<ExpenseAccountProvider>(context,listen: false);

    Color color = expenseAccountProvider.currentIndex == index ? Colors.blue : Colors.grey;
    double targetSize = expenseAccountProvider.currentIndex == index ? initialSize + 7.0 : initialSize;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400), // Animation duration
      width: targetSize,
      height: targetSize,
      margin: EdgeInsets.symmetric(horizontal: expenseAccountProvider.currentIndex == index ? 4.0 : 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,

      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
