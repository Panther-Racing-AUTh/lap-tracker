import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:graphic/graphic.dart';

final supabase = Supabase.instance.client;

class EchartsWidget extends StatefulWidget {
  final List<dynamic> finalList;

  const EchartsWidget({super.key, required this.finalList});

  @override
  State<EchartsWidget> createState() => _EchartsWidgetState();
}

class _EchartsWidgetState extends State<EchartsWidget> {
  final _stream = supabase
      .from('telemetry_system_data')
      .stream(primaryKey: ['id']).order('racing_time', ascending: true);

  @override
  Widget build(BuildContext context) {
    print(widget.finalList);
    return StreamBuilder(
      stream: _stream,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final List<Map<String, dynamic>> lineMarkerData = [];

          snapshot.data?.forEach((data) {
            widget.finalList.forEach((item) {
              print(item);
              lineMarkerData.add(
                {
                  'racing_time': data['racing_time'],
                  'value': data[item],
                  'group': item
                },
              );
              print('The data is : ${lineMarkerData}');
              print(data[item]);
            });

            //   // {'racing_time': '1.05', 'value': 10, 'group': 'rpm'}
            //   // {'racing_time': '1.05', 'value': 1, 'group': 'oil_pressure'}
          });

          var echartWidget = SingleChildScrollView(
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Chart(
                      data: lineMarkerData,
                      variables: {
                        'racing_time': Variable(
                          accessor: (Map datum) =>
                              datum['racing_time'] as String,
                          scale: OrdinalScale(inflate: true),
                        ),
                        'value': Variable(
                          accessor: (Map datum) => datum['value'] as num,
                          scale: LinearScale(
                            tickCount: 10,
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
                              Color.fromARGB(255, 253, 8, 0),
                              Color.fromARGB(255, 230, 255, 1),
                              Color.fromARGB(255, 26, 248, 5),
                              Color.fromARGB(255, 0, 204, 255),
                              Color.fromARGB(255, 68, 0, 255),
                              Color.fromARGB(255, 255, 0, 221),
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
                        // TagAnnotation(
                        //   label: Label(
                        //       '13',
                        //       LabelStyle(
                        //         style: Defaults.textStyle,
                        //         offset: const Offset(0, -10),
                        //       )),
                        //   values: ['Wed', 13],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          return echartWidget;
        }
      },
    );
  }
}
