import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/new_data_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../models/telemetry.dart';
import '../providers/app_setup.dart';

// ignore: must_be_immutable
class Graph extends StatefulWidget {
  Graph({
    required this.list,
    required this.showDetails,
    required this.isMessage,
  });
  List<List<Data>> list;
  bool showDetails;
  bool isMessage;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  //controller initialization
  late ZoomPanBehavior _zoomPanBehavior;
  late RangeController _rangeController;

  @override
  void initState() {
    _rangeController = RangeController(
      start: DateTime(2023, 3, 2, 11, 0, 0),
      end: DateTime(2023, 3, 2, 23, 0, 0),
    );
    _zoomPanBehavior = ZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    AppSetup setup = Provider.of<AppSetup>(context);

    bool includeAllPoints = setup.timeConstraints.first == null;
    print('include all points: ' + includeAllPoints.toString());
    //ratio to not diplay all points
    late var ratio;
    late final minimum;
    late final maximum;
    //all points that exist, a timestamp-value pair with additional metadata such as canbus id name
    List<List<Data>> points = [];
    //Map<String, List<Data>> series = {};

    //list of the lines that will be drawn
    List series = [];

    //Initialize start and end
    if (!includeAllPoints) {
      minimum = setup.timeConstraints[0];
      maximum = setup.timeConstraints[1];
    }

    //if a sensor is selected display data else do not
    if (widget.list.length > 0) {
      //series[a.chartList[i]] = [];

      for (int i = 0; i < widget.list.length; i++) {
        series.add(widget.list[i]);
      }
      print(series.length);
      //print(series[a.chartList[1]]);

      //add points to nested list
      for (int i = 0; i < widget.list.length; i++) {
        points.add([]);

        //calculate the ratio of points to be displayed
        ratio = widget.showDetails ? 4 : 8;

        if (includeAllPoints) {
          ratio = calculateRatio(widget.list[i].length, 10000);
        } else {
          ratio = calculateRatio(
              calculateActualNumberOfPointsForSpecificInterval(
                  _rangeController.start, _rangeController.end, widget.list[i]),
              10000);
        }
        if (widget.isMessage) ratio = 50;
        print('ratio: ' + ratio.toString());

        for (int j = 0; j < series[i].length; j++) {
          if (j % ratio == 0) {
            if (includeAllPoints) {
              points[i].add(widget.list[i][j]);
            } else {
              if (pointPassesCheck(minimum, maximum, widget.list[i][j]))
                points[i].add(widget.list[i][j]);
            }
          }
        }
      }

      //maximum and minimum time period that data represents
      if (includeAllPoints) {
        minimum = DateTime.parse('2023-03-02 ' + points[0].first.timestamp);
        maximum = DateTime.parse('2023-03-02 ' + points[0].last.timestamp);
      }

      _rangeController.start = minimum;
      _rangeController.end = maximum;
      print(points[0][0].canbusId);
      print(points[0][0].canbusIdName);
      print(points[0][0].unit);
      print(points[0][0].canbusTimelineId);
      print(points[0][0].timestamp);
      print(points[0].length);
    }
    //called when zoom button is pressed to adjust interval
    void adjustInterval() {
      setState(() {
        setup.timeConstraints[0] = _rangeController.start;
        setup.timeConstraints[1] = _rangeController.end;
        print('interval 1: ' + setup.timeConstraints[0].toString());
        print('interval 2: ' + setup.timeConstraints[1].toString());
      });
    }

    return (widget.list.length > 0)
        ? Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: screenHeight * 0.65,
                  child: SfCartesianChart(
                    //backgroundColor: Colors.pink,
                    plotAreaBorderWidth: 0,
                    primaryXAxis: DateTimeAxis(
                      visibleMaximum: _rangeController.end,
                      visibleMinimum: _rangeController.start,
                      rangeController: _rangeController,
                      dateFormat: DateFormat.Hms(),
                    ),
                    primaryYAxis: NumericAxis(isVisible: true),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    zoomPanBehavior: _zoomPanBehavior,

                    series: <FastLineSeries<dynamic, dynamic>>[
                      for (int i = 0; i < points.length; i++)
                        FastLineSeries(
                          width: 0.6,
                          animationDuration: 0,
                          dataSource: points[i],
                          xValueMapper: (element, _) {
                            return DateTime.parse(
                                '2023-03-02 ' + element.timestamp);
                          },
                          yValueMapper: (element, _) {
                            return element.value;
                          },
                          name: loggerNamesToPrintedNames[
                              points[i][i].canbusIdName],
                          dataLabelSettings: DataLabelSettings(),
                        )
                    ],
                  ),
                ),
                //check to display menu at the bottom to drag and change limits of chart at bottom of screen
                if (widget.showDetails)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton(
                        child: Text('ZOOM'),
                        onPressed: () => adjustInterval(),
                      ),
                      Expanded(
                        child: Container(
                          child: SfRangeSelector(
                            dragMode: SliderDragMode.both,
                            showLabels: true,
                            showTicks: true,
                            dateIntervalType: DateIntervalType.seconds,
                            min: minimum,
                            max: maximum,
                            dateFormat: DateFormat.Hms(),
                            controller: _rangeController,
                            child: Container(
                              height: screenHeight * 0.1,
                              child: SfCartesianChart(
                                primaryXAxis: DateTimeAxis(
                                  minimum: minimum,
                                  maximum: maximum,
                                  isVisible: false,
                                ),
                                primaryYAxis: NumericAxis(isVisible: false),
                                plotAreaBorderWidth: 0,
                                series: <FastLineSeries<dynamic, dynamic>>[
                                  //feed points of each graph in widget
                                  for (int i = 0; i < points.length; i++)
                                    FastLineSeries(
                                      width: 0.5,
                                      animationDuration: 0,
                                      dataSource: points[i],
                                      xValueMapper: (element, _) {
                                        return (_ % 4 == 0)
                                            ? DateTime.parse('2023-03-02 ' +
                                                element.timestamp)
                                            : null;
                                      },
                                      yValueMapper: (element, _) {
                                        return (_ % 2 == 0)
                                            ? element.value
                                            : null;
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          )
        : Container();
  }
}

int calculateRatio(int actualNumberOfPoints, int numberOfPointsToBeDisplayed) {
  print(numberOfPointsToBeDisplayed);
  print(actualNumberOfPoints);
  print(actualNumberOfPoints / numberOfPointsToBeDisplayed);
  if ((actualNumberOfPoints / numberOfPointsToBeDisplayed).round() == 0)
    return 1;
  return (actualNumberOfPoints / numberOfPointsToBeDisplayed).round();
}

bool pointPassesCheck(DateTime minimum, DateTime maximum, Data point) {
  var minimumString = minimum.toString().replaceRange(0, 11, '');
  var maximumString = maximum.toString().replaceRange(0, 11, '');

  return (point.timestamp.compareTo(minimumString) >= 0 &&
      point.timestamp.compareTo(maximumString) <= 0);
}

int calculateActualNumberOfPointsForSpecificInterval(
    DateTime start, DateTime end, List<Data> list) {
  var startString = start.toString().replaceRange(0, 11, '');
  var endString = end.toString().replaceRange(0, 11, '');
  int counter = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].timestamp.compareTo(startString) >= 0 &&
        list[i].timestamp.compareTo(endString) <= 0) counter++;
  }
  return counter;
}
