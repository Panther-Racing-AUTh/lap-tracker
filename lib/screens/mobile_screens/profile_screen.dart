import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/profile_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/person.dart';
import '../../names.dart';
import '../../providers/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart' as provider;

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

Person? p;

class ProfileScreenState extends State<ProfileScreen> {
  //static const String routeName = '/profile';
  final double coverHeight = 210;

  final double profileHeight = 115;
  //String image = 'images/electronics.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          profile,
        ),
        actions: [
          _buildEditButton(size: 24, padding: 10),
        ],
      ),
      body: (Supabase.instance.client.auth.currentUser == null)
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Text(
                    sign_in_to_see_profile,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<Person>(
              future: getUserProfile(
                  uuid: Supabase.instance.client.auth.currentUser!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  p = snapshot.data;

                  return Profile();
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }

  Widget Profile() {
    ThemeChanger theme = provider.Provider.of<ThemeChanger>(context);
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            buildContent(theme),
          ],
        ),
        //_buildEditButton(size: 30, padding: 10),
      ],
    );
  }

  Widget _buildEditButton({required double size, required double padding}) {
    bool signedIn = supabase.auth.currentSession != null;
    return Container(
      padding: EdgeInsets.all(padding),
      child: IconButton(
        icon: Icon(
          Icons.edit,
          size: size,
          color: (signedIn) ? Colors.black : Color.fromARGB(255, 112, 111, 111),
        ),
        onPressed: () {
          if (signedIn) {
            Navigator.pushNamed(
              context,
              '/profile/edit',
            ).then((_) => setState(() {
                  getUserProfile(
                      uuid: Supabase.instance.client.auth.currentUser!.id);
                  Future.delayed(Duration(seconds: 2));
                  setState(() {});
                }));
          }
        },
      ),
    );
  }

  Widget buildContent(ThemeChanger theme) => Column(
        children: [
          SizedBox(height: 8),
          Text(
            p!.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            p!.role,
            style: TextStyle(
              fontSize: 20,
              color: theme.getCurrentThemeMode() == ThemeData.dark()
                  ? Colors.white.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.7),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSocialIcon(FontAwesomeIcons.google),
              const SizedBox(width: 9),
              buildSocialIcon(FontAwesomeIcons.github),
              const SizedBox(width: 9),
              buildSocialIcon(FontAwesomeIcons.twitter),
              const SizedBox(width: 9),
              buildSocialIcon(FontAwesomeIcons.linkedin),
              const SizedBox(width: 9),
              buildSocialIcon(FontAwesomeIcons.apple),
              const SizedBox(width: 9),
              buildSocialIcon(FontAwesomeIcons.microsoft),
              const SizedBox(width: 9),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Divider(),
          const SizedBox(
            height: 16,
          ),
          buildAbout()
        ],
      );

  Stack buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom), child: buildCoverImage()),
        Positioned(
          top: top,
          child: buildProfileImage(),
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
        color: Colors.grey,
        child: Image.network(
          p!.department_image,
          fit: BoxFit.cover,
        ),
        width: double.infinity,
        height: coverHeight,
      );

  Widget buildProfileImage() => CircleAvatar(
        backgroundColor: Colors.grey.shade800,
        backgroundImage: NetworkImage(p!.image),
        radius: profileHeight / 2,
      );

  Widget buildSocialIcon(IconData icon) => CircleAvatar(
        radius: 25,
        child: Material(
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final url = Uri(
                scheme: 'https',
                host: 'youtube.com',
                path: 'watch',
                queryParameters: {'v': 'dQw4w9WgXcQ'},
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Center(
              child: Icon(
                icon,
                size: 32,
              ),
            ),
          ),
        ),
      );

  Widget buildAbout() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              about,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 16),
            Text(
              p!.about,
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 25,
            )
          ],
        ),
      );
}
