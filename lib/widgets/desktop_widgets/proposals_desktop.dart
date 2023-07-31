import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/race.dart';
import 'package:flutter_complete_guide/queries.dart';
import 'package:flutter_complete_guide/supabase/select_race_track_functions.dart';
import 'package:flutter_complete_guide/screens/desktop_screens/create_new_vehicle_screen.dart';
import 'package:flutter_complete_guide/widgets/drivers_grid.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';

import '../../models/event.dart';
import '../../providers/app_setup.dart';
import '../../screens/desktop_screens/hands_on_screen.dart';
import '../../screens/desktop_screens/proposal_screen.dart';
import '../../supabase/authentication_functions.dart';
import '../chief_engineer_dashboard.dart';

//landing page for dashboard.
class DashBoardDesktop extends StatefulWidget {
  DashBoardDesktop(this.width);
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
    AppSetup setup = Provider.of<AppSetup>(context, listen: true);
    //show the proposal screen to the admin and chief engineer,
    //the task page to the hands on engineer
    return (setup.eventDate.id == 0)
        ? Text('No pools are open...')
        : (setup.role == 'admin' || setup.role == 'chief_engineer')
            ? Overview(widget.width)
            : HandsOnScreen();
  }
}
