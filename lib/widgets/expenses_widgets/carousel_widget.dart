import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardTitle;
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final Color cardColor;
  final double totalAmount;

  CreditCardWidget({
    required this.cardTitle,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cardColor,
    required this.totalAmount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17,vertical: 12),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      height: MediaQuery.of(context).size.height *.25,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {

                  print("niaou");

                },
                child: SizedBox(
                    width: 150,
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          cardTitle,
                          style: TextStyle(
                              fontSize: 15
                          ),
                        ),
                        Icon(Icons.arrow_drop_down,color: Colors.grey.shade700,)
                      ],
                    )
                ),
              ),
              SizedBox(
                  width: 150,
                  child: Text(
                    "\$ ${double.parse((totalAmount).toStringAsFixed(2))}",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),

                    textAlign: TextAlign.start,
                  )
              ),
              Spacer(),
              SizedBox(
                  width:150,
                  child: Row(
                    children: [
                      Icon(Icons.arrow_circle_down_rounded,size: 25,),
                      Text(
                        " Income",
                        style: TextStyle(
                            fontSize: 18
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  )
              ),
              SizedBox(
                  width: 150,
                  child: Text(
                    " \$ ${double.parse((totalAmount).toStringAsFixed(2))}",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  )
              ),
            ],
          ),
          Spacer(),
          Column(
            children: [
              SizedBox(
                width: 150,
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () {

                      },
                      child: const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 10,horizontal: 2),
                        child: Icon(Icons.more_vert),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              SizedBox(
                  width:150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.arrow_circle_up_rounded,size: 25,),
                      Text(
                        " Expenses",
                        style: TextStyle(
                            fontSize: 18
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  )
              ),
              SizedBox(
                  width: 150,
                  child: Text(
                    " \$ ${double.parse((totalAmount).toStringAsFixed(2))}",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  )
              ),
            ],
          ),

        ],
      ),

    );

  }
}


class MultiCardSlider extends StatefulWidget {
  final List<CreditCardWidget> cards;

  MultiCardSlider({
    required this.cards
  });

  @override
  _MultiCardSliderState createState() => _MultiCardSliderState();
}

class _MultiCardSliderState extends State<MultiCardSlider> {
  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.cards.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                  }
                  return Center(
                    child: SizedBox(
                      height: Curves.easeInOut.transform(value) * 220,
                      child: child,
                    ),
                  );
                },
                child: CreditCardWidget(
                  cardTitle: widget.cards[index].cardTitle,
                  cardNumber: widget.cards[index].cardNumber,
                  cardHolder: widget.cards[index].cardHolder,
                  expiryDate: widget.cards[index].expiryDate,
                  totalAmount: widget.cards[index].totalAmount,
                  cardColor: Colors.blue,
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.cards.length,
                (index) => buildIndicator(index,8),
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(int index, double initialSize) {
    Color color = _currentPageIndex == index ? Colors.blue : Colors.grey;
    double targetSize = _currentPageIndex == index ? initialSize + 7.0 : initialSize;

    return AnimatedContainer(
      duration: Duration(milliseconds: 400), // Animation duration
      width: targetSize,
      height: targetSize,
      margin: EdgeInsets.symmetric(horizontal: 4.0),
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
