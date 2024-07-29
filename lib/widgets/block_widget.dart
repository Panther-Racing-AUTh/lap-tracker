import 'package:flutter/material.dart';

//Widget created to edit the box menu
Widget blockWidget({
  required String title,
  required BuildContext context,
  required Color color,
  required String page,
  required IconData icon,
}) {
  final landscape = MediaQuery.of(context).orientation == Orientation.landscape;

  return InkWell(
    onTap: () => Navigator.of(context).pushNamed(page),
    splashColor: Theme.of(context).primaryColor,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      height: landscape ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.23,
      width: landscape ? MediaQuery.of(context).size.width * 0.20 : MediaQuery.of(context).size.width * 0.33,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.7),
            color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: landscape ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Icon(
            icon,
            size: landscape ? MediaQuery.of(context).size.height * 0.04 : MediaQuery.of(context).size.height * 0.06,
            color: Colors.black,
          ),

        ],
      ),
    ),
  );
}
