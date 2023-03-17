import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../models/telemetry.dart';

// ignore: must_be_immutable
class Graph extends StatefulWidget {
  Graph(
      {required this.dataList,
      required this.showDetails,
      required this.isMessage});
  bool showDetails;
  bool isMessage;
  List<Data> dataList;
  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
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

    late var ratio;
    if (widget.dataList.length > 100) ratio = widget.showDetails ? 4 : 8;
    if (widget.isMessage) ratio = 50;
    List<Data> points = [];
    for (int i = 0; i < widget.dataList.length; i++) {
      if (i % ratio == 0) points.add(widget.dataList[i]);
    }
    _rangeController.start =
        DateTime.parse('2023-03-02 ' + points.first.timestamp);
    _rangeController.end =
        DateTime.parse('2023-03-02 ' + points.last.timestamp);
    print(points.length);
    final minimum = DateTime.parse('2023-03-02 ' + points.first.timestamp);
    final maximum = DateTime.parse('2023-03-02 ' + points.last.timestamp);

    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: screenHeight * 0.65,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              visibleMaximum: _rangeController.end,
              visibleMinimum: _rangeController.start,
              rangeController: _rangeController,
              dateFormat: DateFormat.Hms(),
            ),
            primaryYAxis: NumericAxis(isVisible: true),
            legend: Legend(isVisible: widget.showDetails),
            //tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: _zoomPanBehavior,

            series: <FastLineSeries<dynamic, dynamic>>[
              FastLineSeries(
                width: 0.6,
                animationDuration: 0,
                dataSource: points,
                xValueMapper: (element, _) {
                  return DateTime.parse('2023-03-02 ' + element.timestamp);
                },
                yValueMapper: (element, _) {
                  return element.value;
                },
                name: 'Name',
                dataLabelSettings: DataLabelSettings(),
              )
            ],
          ),
        ),
        if (widget.showDetails)
          SfRangeSelector(
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
                  FastLineSeries(
                    width: 0.5,
                    animationDuration: 0,
                    dataSource: points,
                    xValueMapper: (element, _) {
                      return (_ % 4 == 0)
                          ? DateTime.parse('2023-03-02 ' + element.timestamp)
                          : null;
                    },
                    yValueMapper: (element, _) {
                      return (_ % 2 == 0) ? element.value : null;
                    },
                  )
                ],
              ),
            ),
          ),
      ],
    ));
  }
}
