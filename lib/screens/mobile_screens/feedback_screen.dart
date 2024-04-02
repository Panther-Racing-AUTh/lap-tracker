import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_files/wdgets/edit_meeting_form_widget.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController feedbackText=TextEditingController(text: '');
  bool isSubmitted=false;
  RacingTeamRoles role=RacingTeamRoles.category;


  @override
  Widget build(BuildContext context) {
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
        title: Text(feedback),
      ),
      body: isSubmitted ?
      ListView(
          children:[
            Image.asset('assets/feedback.png'),
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
            Image.asset('assets/feedback.png'),

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
                    'Please send us your feedback!',
                    style: TextStyle(fontSize: 22.0),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 26.0),
                  Center(
                    child: Container(
                      child: FiveStarRating(),
                    ),
                  ),

                  SizedBox(height: 26.0),
                  TextFormField(
                    maxLines: 5,
                    controller: feedbackText,
                    decoration: InputDecoration(
                      hintText: 'Enter your feedback here...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)
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
                  if(feedbackText.text!=''){
                    setState(() {
                      isSubmitted=true;
                    });
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No Feedback Text Found!'),
                      ),
                    );
                  }
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
            children: List.generate(
              5,
                  (index) {
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
