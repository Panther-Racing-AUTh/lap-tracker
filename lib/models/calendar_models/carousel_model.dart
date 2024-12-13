import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/admin_panel_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/calendar_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/chart_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/chat_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/data_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/profile_screen.dart';
import 'package:flutter_complete_guide/screens/mobile_screens/settings_screen.dart';
import 'package:provider/provider.dart';


class CutsomCarouselWidget extends StatefulWidget {
  double height;
  EdgeInsets margin;
  Axis axisDirection;
  Image? imageBackground;

  BoxDecoration decoration;
  TextStyle textStyle;

  List itemList;
  List<dynamic>? iconList;

  CutsomCarouselWidget({super.key,required this.height,this.imageBackground,this.iconList,this.margin=EdgeInsets.zero,required this.itemList,this.axisDirection=Axis.horizontal,BoxDecoration? decoration,TextStyle? textStyle}): decoration = decoration ?? BoxDecoration(color: Colors.white), textStyle = textStyle ?? TextStyle();

  @override
  State<CutsomCarouselWidget> createState() => _CutsomCarouselWidgetState();
}

class _CutsomCarouselWidgetState extends State<CutsomCarouselWidget> {

  int _currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
              items: widget.itemList.asMap().entries.map((entry) {
                final spaceLeftLength=widget.itemList.length-widget.iconList!.length;
                for(int i=0;i<spaceLeftLength;i++){
                  widget.iconList!.add(widget.iconList!.first);
                }
                final index = entry.key;
                final item = entry.value;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin:widget.margin,
                  decoration: widget.decoration,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    onPressed: () {
                      setState(() {
                        switch (item) {
                          case 'Profile':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),));

                            print('Selected Profile');
                            break;
                          case 'Chat':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
                            print('Selected Chat');
                            break;
                          case 'Data':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DataScreen(),));

                            print('Selected Data');
                            break;
                          case 'Calendar':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarScreen(),));

                            print('Selected Calendar');
                            break;
                          case 'Chart':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChartScreen(),));

                            print('Selected Chart');
                            break;
                          case 'Admin Panel':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanel(),));

                            print('Selected Admin Panel');
                            break;
                          case 'Settings':
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),));

                            print('Selected Settings');
                            break;
                          default:
                            print('Unknown item');
                        }
                      });
                    },
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.4, // Adjust the opacity value (0.0 to 1.0)
                          child: widget.imageBackground != null ? Image.asset(
                            'assets/RRAS.png',  // Replace with the path to your image asset
                            fit: BoxFit.scaleDown,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ) : Container(),
                        ),
                        Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.iconList!=null ?
                                widget.iconList![index]: Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  item.toString(),
                                  style: widget.textStyle,
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: widget.height,
                animateToClosest: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                scrollDirection: widget.axisDirection,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

              )
          ),
          SizedBox(height: 16),
          buildBullets(),
        ],
      ),

    );
  }


  Widget buildBullets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemList.length, (index) {
        return buildBullet(index);
      }),
    );
  }

  Widget buildBullet(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width:  _currentIndex == index ? 15 : 8,
        height: _currentIndex == index ? 15 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.black : Colors.grey,
        ),
      ),
    );
  }
}



class PremiumCustomCarousel extends StatefulWidget {
  double height;
  double margin;
  Axis axisDirection;

  BoxDecoration decoration;
  TextStyle textStyle;

  List itemList;

  PremiumCustomCarousel({super.key,required this.height,this.margin=0,required this.itemList,this.axisDirection=Axis.horizontal,BoxDecoration? decoration,TextStyle? textStyle}): decoration = decoration ?? BoxDecoration(color: Colors.white), textStyle = textStyle ?? TextStyle();


  @override
  State<PremiumCustomCarousel> createState() => _PremiumCustomCarouselState();
}

class _PremiumCustomCarouselState extends State<PremiumCustomCarousel> {
  int _currentIndex=0;


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CarouselSlider(
              items: widget.itemList.map((item) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: widget.margin),
                  decoration: widget.decoration,
                  child: Center(child: Text(item.toString(),style: widget.textStyle,)),
                );
              }).toList(),
              options: CarouselOptions(
                height: widget.height,
                animateToClosest: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                scrollDirection: widget.axisDirection,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },

              )
          ),
          SizedBox(height: 16),
          buildBullets(),
        ],
      ),

    );
  }


  Widget buildBullets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.itemList.length, (index) {
        return buildBullet(index);
      }),
    );
  }

  Widget buildBullet(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        width:  _currentIndex == index ? 18 : 8,
        height: _currentIndex == index ? 18 : 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.black : Colors.grey.shade400,
        ),
      ),
    );
  }
}


class PremiumCustomCard extends StatelessWidget {
  List<dynamic> firstCard;
  List<List<dynamic>> secondCard;

  PremiumCustomCard({
    super.key,
    List<dynamic>? firstCard,
    List<List<dynamic>>? secondCard,
  }) : firstCard= firstCard ?? List.generate(3, (index) => ""),secondCard = secondCard ?? List.generate(3, (index) {
    IconData iconData = Icons.circle_outlined; // You can change the icon as needed
    Icon icon = Icon(iconData);
    String text = "";
    return [icon, text];
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Center(
              child: Column(
                children: [
                  Text(firstCard[0]),
                  Text(firstCard[1]),
                  Text(firstCard[2])
                ],
              ),
            ),
          ),
          ListView(
            children: [
              ListTile(
                leading: Icon(secondCard[0][0]),
                title: Text(secondCard[0][1]),
              ),
              ListTile(
                leading: Icon(secondCard[1][0]),
                title: Text(secondCard[1][1]),
              ),
              ListTile(
                leading: Icon(secondCard[2][0]),
                title: Text(secondCard[2][1]),
              ),
            ],
          ),
          MaterialButton(
            onPressed: (){},

          ),
        ],
      ),
    );
  }

}

