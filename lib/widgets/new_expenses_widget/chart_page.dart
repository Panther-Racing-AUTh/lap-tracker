import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class TradingData {
  final DateTime date;
  final double price;

  TradingData({required this.date, required this.price});
}

class TradingLineChart extends StatefulWidget {
  final List<TradingData> data;

  TradingLineChart({required this.data});

  @override
  _TradingLineChartState createState() => _TradingLineChartState();
}

class _TradingLineChartState extends State<TradingLineChart> {
  late List<TradingData> _currentData;

  @override
  void initState() {
    super.initState();
    _currentData = widget.data;
  }
  
  
  String formatDouble(double value) {
    // Create NumberFormat instance for formatting
    final formatter = NumberFormat('#,##0.00', 'en_US');

    // Format the double value
    return formatter.format(value);
  }
  void _updateDataForTimePeriod(String timePeriod) {
    DateTime today = DateTime.now();
    setState(() {
      switch (timePeriod) {
        case 'Today':
          _currentData = widget.data.where((data) => data.date.day == today.day).toList();
          break;
        case 'Week':
          _currentData = widget.data.where((data) => today.difference(data.date).inDays <= 7).toList();
          break;
        case 'Month':
          _currentData = widget.data.where((data) => data.date.month == today.month).toList();
          break;
        case 'Year':
          _currentData = widget.data.where((data) => data.date.year == today.year).toList();
          break;
        case '6 Years':
          _currentData = widget.data.where((data) => today.year - data.date.year <= 6).toList();
          break;
        case 'All':
          _currentData = widget.data;
          break;
        default:
          _currentData = widget.data;
          break;
      }
    });
  }

  double findMinValue(List<TradingData> data){
    double minVal=data.first.price;
    for(int i=0;i<data.length;i++){
      if(minVal>data[i].price){
        minVal=data[i].price;
      }
    }
    return minVal -500;
  }
  double findMaxValue(List<TradingData> data){
    double maxVal=data.first.price;
    for(int i=0;i<data.length;i++){
      if(maxVal<data[i].price){
        maxVal=data[i].price;
      }
    }
    return maxVal + 500;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height* .4,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [

          SfCartesianChart(
            plotAreaBorderWidth: 0,
            onMarkerRender: (args) {

              // Check your specific condition
                args.color = Colors.red;
                args.markerHeight = 20;
                args.markerWidth = 20;
                args.shape = DataMarkerType.diamond;
                args.borderColor = Colors.green;
                args.borderWidth = 2;
            },
            primaryXAxis: DateTimeAxis(
              isVisible: false,
              majorGridLines: MajorGridLines(width: 0),
              dateFormat: DateFormat.MMMd(),
            ),
            primaryYAxis: NumericAxis(
              isVisible: true,
              minimum: findMinValue(_currentData),
              maximum: findMaxValue(_currentData),
              // Set the maximum value for the y-axis
            ),
            series: <CartesianSeries>[
              LineSeries<TradingData, DateTime>(
                dataSource: _currentData,
                xValueMapper: (TradingData price, _) => price.date,
                yValueMapper: (TradingData price, _) => price.price,
                enableTooltip: true,
                width: 3,
                dataLabelSettings: DataLabelSettings(isVisible: false),
                markerSettings: MarkerSettings(isVisible: false),
              ),
            ],
            tooltipBehavior: TooltipBehavior(
              enable: true,
              builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                if (data is TradingData) {
                  final TradingData tradingData = data;
                  return Container(
                    width: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Trading Price',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Container(
                          height: 1,
                          width: 150,
                          color: Colors.blue,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Date: ${DateFormat("dd/MMM/yyyy").format(tradingData.date)}',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Price: \$ ${formatDouble(tradingData.price)}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimePeriodButton('Today'),
                _buildTimePeriodButton('Week'),
                _buildTimePeriodButton('Month'),
                _buildTimePeriodButton('Year'),
                _buildTimePeriodButton('6 Years'),
                _buildTimePeriodButton('All'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePeriodButton(String timePeriod) {
    return GestureDetector(
      onTap: () => _updateDataForTimePeriod(timePeriod),
      child: Container(
        color: Colors.grey.withOpacity(0.3),
        margin:  EdgeInsets.symmetric(horizontal: 6.0,vertical: 5),
        padding:  EdgeInsets.symmetric(horizontal: 6.0,vertical: 5),
        child: Text(timePeriod,style: TextStyle(
          fontSize: 16,
          color: Colors.white
        ),),
      ),
    );
  }
}
