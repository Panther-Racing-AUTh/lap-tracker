import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:flutter_complete_guide/queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/app_setup.dart';
import '../supabase/profile_functions.dart';

class ProfilePreview extends StatelessWidget {
  ProfilePreview({super.key});

  @override
  Widget build(BuildContext context) {
    AppSetup appSetup = Provider.of<AppSetup>(context);
    return Subscription(
      options: SubscriptionOptions(
          document: gql(getUserProfileStream),
          variables: {"userId": appSetup.supabase_id}),
      builder: (result) {
        if (result.hasException) {
          print(result.exception);
          return Text(result.exception.toString());
        }
        if (result.isLoading) {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
        Person p = Person.fromJson(result.data!['users'][0]);
        print(result.data);
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
      },
    );

    FutureBuilder<List>(
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
