import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/supabase/select_race_track_functions.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/create_new_vehicle_screen.dart';
import 'package:flutter_complete_guide/widgets/drivers_grid.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../providers/app_setup.dart';
import '../../screens/desktop_screens/hands_on_screen.dart';
import '../../screens/desktop_screens/proposal_screen.dart';
import '../../supabase/authentication_functions.dart';
import '../chief_engineer_dashboard.dart';

class DashBoardDesktop extends StatefulWidget {
  DashBoardDesktop(double this.width);
  double width;
  @override
  State<DashBoardDesktop> createState() => _DashBoardDesktopState();
}

class _DashBoardDesktopState extends State<DashBoardDesktop>
    with AutomaticKeepAliveClientMixin<DashBoardDesktop> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    AppSetup setup = Provider.of<AppSetup>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return (setup.role == 'admin' || setup.role == 'chief_engineer')
        ? Overview(widget.width)
        : HandsOnScreen();
  }
}
