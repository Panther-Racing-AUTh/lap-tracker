import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/feeback_model.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/weekly_report_files/models/provider.dart';
import 'package:flutter_complete_guide/widgets/calendar_widgets/edit_meeting_form_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class FeedbackScreen extends StatefulWidget {
  FeedbackItem feedbackItem;
  int index;

  FeedbackScreen({super.key,required this.feedbackItem,required this.index});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController dialogText=TextEditingController(text: '');
  TextEditingController feedbackText=TextEditingController(text: '');

  bool isSaveable=false;
  bool isSubmitted=false;
  RacingTeamRoles role=RacingTeamRoles.category;

  late FeedbackItem tempFeedbackItem;

  @override
  void initState(){
    tempFeedbackItem=widget.feedbackItem;
  }


  @override
  Widget build(BuildContext context) {
    final feedbackProvider=Provider.of<FeedbackProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: GestureDetector(
          child: Icon(
              Icons.close
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text('Feedback'),
      ),
      body: isSubmitted ?
      ListView(
          children:[
            Image.asset('assets/images/feedback.png'),
            Container(

              margin: EdgeInsets.only(top:1,left: 15,right: 15),
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0,0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Thanks for your feedback!',
                    style: TextStyle(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 6.0),
                  Text(
                    'We will consider it carefully.',
                    style: TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  MaterialButton(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Go Back',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),

                ],
              ),
            ),

          ]
      )
          : ListView(
          children:[
            Image.asset('assets/images/feedback.png'),

            Container(

              margin: EdgeInsets.only(top:1,left: 15,right: 15),
              padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0,0), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome ${role.getString()}!',
                    style: TextStyle(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Weekly feedback!',
                    style: TextStyle(fontSize: 12.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 26.0),
                 Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 58.0),
                    child: Container(
                    ),
                  ),

                  SizedBox(height: 26.0),
                  Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                  SizedBox(height: 12.0),
                  Container(
                      margin:EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weekly To-Do List',style: TextStyle(fontSize: 20),),
                        ],
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 0),
                        height: 260,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: List.generate(widget.feedbackItem.checklist.length, (index) => Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                          child: Row(
                            children: [
                              Checkbox(
                                value: tempFeedbackItem.checklist[index].isChecked,
                                onChanged: (value) {
                                    setState(() {
                                      tempFeedbackItem.checklist[index].isChecked=value ?? false;
                                    });
                                  },
                              ),
                              Text(
                                tempFeedbackItem.checklist[index].checkText,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: tempFeedbackItem.checklist[index].isChecked ? Colors.grey.shade400 : Colors.black,
                                    decoration: tempFeedbackItem.checklist[index].isChecked ? TextDecoration.lineThrough : TextDecoration.none
                                ),
                              )
                            ],
                          ),
                        )),
                      )
                    ),
                  ),
                  SizedBox(height: 26.0),
                  Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                  SizedBox(height: 26.0),
                  Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          textAlign: TextAlign.center,
                          'Admins Message',
                          style: TextStyle(
                            fontSize: 20
                          ),
                        ),
                      )
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Center(
                      child: tempFeedbackItem.message!='' ? Text('${tempFeedbackItem.message}') : Text('No Message')
                  ),
                  SizedBox(height: 26.0),
                  Container(height: 1,width: MediaQuery.of(context).size.width,color: Colors.grey,),
                  SizedBox(height: 12.0),
                  Container(
                      margin:EdgeInsets.only(left: 16,bottom: 10,top: 10),
                      child: Text('Message(optional)',style: TextStyle(fontSize: 20),)
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      maxLines: 5,
                      controller: feedbackText,
                      decoration: InputDecoration(
                        hintText: 'Enter your feedback here...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 18),
              child: MaterialButton(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                color: Colors.green,
                textColor: Colors.white,
                onPressed: () {
                  // Add your feedback submission logic here
                  setState(() {
                    feedbackProvider.feedbackList[widget.index]=tempFeedbackItem;
                    isSubmitted=true;
                  });

                },
                child: Text('Submit Feedback',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ),
          ]
      ),
    );
  }
}




class FiveStarRating extends StatefulWidget {
  @override
  _FiveStarRatingState createState() => _FiveStarRatingState();
}

class _FiveStarRatingState extends State<FiveStarRating> {
  double _rating = 0.0;
  double _starSize = 50.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        // Calculate the rating based on tap position
        setState(() {
          _rating = ((details.localPosition.dx / _starSize + 1).clamp(0.0, 5.0)).floorToDouble();
          print(_rating);
        });
      },
      onPanUpdate: (details) {
        // Calculate the rating based on drag position
        setState(() {
          _rating = ((details.localPosition.dx / _starSize + 1).clamp(0.0, 5.0)).floorToDouble();
          print(_rating);
        });
      },
      child: Stack(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    // Set the rating when tapping on a star
                    setState(() {
                      _rating = index + 1.0;
                      print(_rating);
                    });
                  },
                  child: Icon(
                    Icons.star,
                    size: _starSize,
                    color: index < _rating.floor() ? Colors.yellow : Colors.grey,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              5,
                  (index) {
                return Container(
                  width: _starSize,
                  height: _starSize,
                  color: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


