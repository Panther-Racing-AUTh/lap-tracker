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
    child: !landscape
        //The sizes of the box when in portrait mode
        ? Container(
            //specified the size of the menu box

            height: MediaQuery.of(context).size.height * 0.23,
            width: MediaQuery.of(context).size.width * 0.33,

            padding: const EdgeInsets.all(15),

            //Wrapped in fitted box so both the title and icon can resize
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.035,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Icon(
                    icon,
                    size: MediaQuery.of(context).size.height * 0.04,
                    color: Colors.black,
                  )
                ],
              ),
            ),
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
          )
//The sizes of the box when in landscape mode
        : Container(
            //specified the size of the menu box

            height: MediaQuery.of(context).size.height * 0.23,
            width: MediaQuery.of(context).size.width * 0.20,

            padding: const EdgeInsets.all(15),

            //Wrapped in fitted box so both the title and icon can resize
            child: FittedBox(
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Icon(
                    icon,
                    size: MediaQuery.of(context).size.height * 0.04,
                    color: Colors.black,
                  )
                ],
              ),
            ),
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
          ),
  );
}
