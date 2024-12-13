import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/new_expenses_widget/models/expense_item.dart';

class ExpenseListWidget extends StatelessWidget {
  final List<ExpenseItem> expenseList;

  ExpenseListWidget({required this.expenseList});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: expenseList.length,
        itemBuilder: (context, index) {
          return buildExpenseListItem(context, expenseList[index]);
        },
      ),
    );
  }

  Widget buildExpenseListItem(BuildContext context, ExpenseItem expenseItem) {
    Color itemColor = expenseItem.amount < 0 ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1);

    return GestureDetector(
      onTap: () {
        _showExpenseDetailsDialog(context, expenseItem);
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(5),
          leading: CircleAvatar(
            backgroundColor: itemColor,
            child: Icon(
              expenseItem.amount < 0 ? Icons.arrow_downward : Icons.arrow_upward,
              color: expenseItem.amount < 0 ? Colors.orange : Colors.green,
            ),
          ),
          title: Container(
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              expenseItem.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
            ),
          ),
          subtitle: Text(
            convertDateTimeToString(expenseItem.dateTime),
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: Container(
            width: MediaQuery.of(context).size.width * .32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${expenseItem.amount < 0 ? '-' : '+'} \$${formatAmount(expenseItem.amount.abs())}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: expenseItem.amount < 0 ? Colors.red : Colors.green,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.place,size: 12,),
                    Text(
                      '${expenseItem.location}',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showExpenseDetailsDialog(BuildContext context, ExpenseItem expenseItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Expense Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 16),
                _buildDetailRow(Icons.label, 'Name', expenseItem.name),
                _buildDetailRow(Icons.attach_money, 'Amount', expenseItem.amount<0 ? '- \$${formatAmount(expenseItem.amount)}' : '+ \$${formatAmount(expenseItem.amount)}'),
                _buildDetailRow(Icons.calendar_today, 'Date', _formatDateTime(expenseItem.dateTime)),
                _buildDetailRow(Icons.location_on, 'Location', expenseItem.location),
                SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(12)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          SizedBox(width: 16),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }



  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
  }


  String convertDateTimeToString(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
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
