import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class EchartsPage extends StatefulWidget {
  EchartsPage({Key? key}) : super(key: key);

  @override
  State<EchartsPage> createState() => _EchartsPageState();
}

class _EchartsPageState extends State<EchartsPage> {
  final _stream = supabase
      .from('telemetry_system_data')
      .stream(primaryKey: ['id']).order('racing_time', ascending: true);

  @override
  Widget build(BuildContext context) {
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
              lineMarkerData.add({
                'racing_time': data['racing_time'],
                'value': data['rpm'],
                'group': 'rpm'
              });
              lineMarkerData.add(
                {
                  'racing_time': data['racing_time'],
                  'value': data['oil_pressure'],
                  'group': 'oil_pressure'
                },
              );

              print(lineMarkerData);
              // {'racing_time': '1.05', 'value': 10, 'group': 'rpm'}
              // {'racing_time': '1.05', 'value': 1, 'group': 'oil_pressure'
            });

            var echartWidget = SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: MediaQuery.of(context).size.height * 0.9,
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
            );

            return echartWidget;
          }
        });
  }
}
