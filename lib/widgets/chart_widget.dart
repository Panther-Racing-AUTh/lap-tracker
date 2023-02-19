import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:flutter_complete_guide/names.dart';

import './echarts_data.dart';

class EchartsPage extends StatelessWidget {
  EchartsPage({Key? key}) : super(key: key);

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return //Scaffold(
        //key: _scaffoldKey,
        //appBar: AppBar(
        //  title: Text(chart_widget_motor_charts),
        //),
        //backgroundColor: Colors.white,
        //body:
        SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 500,
              height: 300,
              child: Chart(
                data: lineMarkerData,
                variables: {
                  'racing_time': Variable(
                    accessor: (Map datum) => datum['racing_time'] as String,
                    scale: OrdinalScale(inflate: true),
                  ),
                  'value': Variable(
                    accessor: (Map datum) => datum['value'] as num,
                    scale: LinearScale(
                      max: 15,
                      min: -3,
                      tickCount: 7,
                      formatter: (v) => '${v.toInt()}',
                    ),
                  ),
                  'group': Variable(
                    accessor: (Map datum) => datum['group'] as String,
                  ),
                },
                elements: [
                  LineElement(
                    position: Varset('racing_time') *
                        Varset('value') /
                        Varset('group'),
                    color: ColorAttr(
                      variable: 'group',
                      values: [
                        const Color(0xff5470c6),
                        const Color(0xff91cc75),
                      ],
                    ),
                  ),
                ],
                axes: [
                  Defaults.horizontalAxis,
                  Defaults.verticalAxis,
                ],
                selections: {
                  'tooltipMouse': PointSelection(on: {
                    GestureType.hover,
                  }, devices: {
                    PointerDeviceKind.mouse
                  }, variable: 'racing_time', dim: Dim.x),
                  'tooltipTouch': PointSelection(on: {
                    GestureType.scaleUpdate,
                    GestureType.tapDown,
                    GestureType.longPressMoveUpdate
                  }, devices: {
                    PointerDeviceKind.touch
                  }, variable: 'racing_time', dim: Dim.x),
                },
                tooltip: TooltipGuide(
                  followPointer: [true, true],
                  align: Alignment.topLeft,
                  variables: ['group', 'value'],
                ),
                crosshair: CrosshairGuide(
                  followPointer: [false, true],
                ),
                annotations: [
                  LineAnnotation(
                    dim: Dim.y,
                    value: 11.14,
                    style: StrokeStyle(
                      color: const Color(0xff5470c6).withAlpha(100),
                      dash: [2],
                    ),
                  ),
                  LineAnnotation(
                    dim: Dim.y,
                    value: 1.57,
                    style: StrokeStyle(
                      color: const Color(0xff91cc75).withAlpha(100),
                      dash: [2],
                    ),
                  ),

                  // MarkAnnotation(
                  //   relativePath:
                  //       Paths.circle(center: Offset.zero, radius: 5),
                  //   style: Paint()..color = const Color(0xff5470c6),
                  //   values: ['Wed', 13],
                  // ),
                  // MarkAnnotation(
                  //   relativePath:
                  //       Paths.circle(center: Offset.zero, radius: 5),
                  //   style: Paint()..color = const Color(0xff5470c6),
                  //   values: ['Sun', 9],
                  // ),
                  // MarkAnnotation(
                  //   relativePath:
                  //       Paths.circle(center: Offset.zero, radius: 5),
                  //   style: Paint()..color = const Color(0xff91cc75),
                  //   values: ['Tue', -2],
                  // ),
                  // MarkAnnotation(
                  //   relativePath:
                  //       Paths.circle(center: Offset.zero, radius: 5),
                  //   style: Paint()..color = const Color(0xff91cc75),
                  //   values: ['Thu', 5],
                  // ),
                  // TagAnnotation(
                  //   label: Label(
                  //       '13',
                  //       LabelStyle(
                  //         style: Defaults.textStyle,
                  //         offset: const Offset(0, -10),
                  //       )),
                  //   values: ['Wed', 13],
                  // ),
                  // TagAnnotation(
                  //   label: Label(
                  //       '9',
                  //       LabelStyle(
                  //         style: Defaults.textStyle,
                  //         offset: const Offset(0, -10),
                  //       )),
                  //   values: ['Sun', 9],
                  // ),
                  // TagAnnotation(
                  //   label: Label(
                  //       '-2',
                  //       LabelStyle(
                  //         style: Defaults.textStyle,
                  //         offset: const Offset(0, -10),
                  //       )),
                  //   values: ['Tue', -2],
                  // ),
                  // TagAnnotation(
                  //   label: Label(
                  //       '5',
                  //       LabelStyle(
                  //         style: Defaults.textStyle,
                  //         offset: const Offset(0, -10),
                  //       )),
                  //   values: ['Thu', 5],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      //),
    );
  }
}
