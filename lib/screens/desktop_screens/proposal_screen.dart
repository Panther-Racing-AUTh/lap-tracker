import 'package:flutter/material.dart';

class ProposalPage extends StatefulWidget {
  const ProposalPage({super.key});

  @override
  State<ProposalPage> createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  @override
  void initState() {
    print('drew proposal page');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: TextField(),
                  width: screenWidth * 0.3,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: TextField(),
                  width: screenWidth * 0.3,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reason',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: TextField(),
                  width: screenWidth * 0.3,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Initial Part value',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: TextField(),
                  width: screenWidth * 0.3,
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Changed Part value',
                  style: TextStyle(fontSize: 20),
                ),
                Container(
                  child: TextField(),
                  width: screenWidth * 0.3,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
