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
    //AppSetup a = Provider.of<AppSetup>(context);
    late var ratio;
    late final minimum;
    late final maximum;
    List<List<Data>> points = [];
    //Map<String, List<Data>> series = {};
    List series = [];

    if (widget.list.length > 0) {
      //series[a.chartList[i]] = [];

      for (int i = 0; i < widget.list.length; i++) {
        series.add(widget.list[i]);
      }
      print(series.length);
      //print(series[a.chartList[1]]);
      ratio = widget.showDetails ? 4 : 8;
      if (widget.isMessage) ratio = 50;

      for (int i = 0; i < widget.list.length; i++) {
        points.add([]);
        for (int j = 0; j < series[i].length; j++) {
          if (j % ratio == 0) points[i].add(widget.list[i][j]);
        }
      }

      minimum = DateTime.parse('2023-03-02 ' + points[0].first.timestamp);
      maximum = DateTime.parse('2023-03-02 ' + points[0].last.timestamp);
      _rangeController.start = minimum;
      _rangeController.end = maximum;
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
                    //tooltipBehavior: TooltipBehavior(enable: true),
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
                          name: m[points[i][i].canbusIdName],
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
                          for (int i = 0; i < points.length; i++)
                            FastLineSeries(
                              width: 0.5,
                              animationDuration: 0,
                              dataSource: points[i],
                              xValueMapper: (element, _) {
                                return (_ % 4 == 0)
                                    ? DateTime.parse(
                                        '2023-03-02 ' + element.timestamp)
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
            ),
          )
        : Container();
  }
}
