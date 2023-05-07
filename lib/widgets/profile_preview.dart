import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:provider/provider.dart';

import '../providers/app_setup.dart';
import '../supabase/profile_functions.dart';

class ProfilePreview extends StatelessWidget {
  ProfilePreview({super.key});

  @override
  Widget build(BuildContext context) {
    AppSetup appSetup = Provider.of<AppSetup>(context);
    return FutureBuilder<List>(
      future: getUserProfile(id: appSetup.supabase_id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Person p = snapshot.data![1];
          return Container(
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(p.image),
                ),
                SizedBox(width: 15),
                Text(p.name)
              ],
            ),
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}
