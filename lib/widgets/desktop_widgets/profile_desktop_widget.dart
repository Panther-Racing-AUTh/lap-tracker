import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../supabase/profile_functions.dart';

final double coverHeight = 150;
Person? p;
final double profileHeight = 115;
var profileImageEdgeRadius = 20.0;

class ProfileDesktop extends StatefulWidget {
  @override
  State<ProfileDesktop> createState() => _ProfileDesktopState();
}

class _ProfileDesktopState extends State<ProfileDesktop> {
  late Future<Person> dataFuture;

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession != null)
      dataFuture =
          getUserProfile(uuid: Supabase.instance.client.auth.currentUser!.id);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);

    return (Supabase.instance.client.auth.currentUser == null)
        ? Container(
            height: height,
            child: Center(
              child: Text(
                'Sign In to see your profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          )
        : FutureBuilder<Person>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                p = snapshot.data;
                return Container(
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: (width >= 1175) ? width * 0.6 : width * 0.75,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: buildTop(width, height * 0.15),
                            ),
                            (width < 1175)
                                ? Container(
                                    padding: EdgeInsets.only(left: 20, top: 20),
                                    child: nameAndRole())
                                : Container(),
                            Container(
                              padding: EdgeInsets.fromLTRB(35, 30, 10, 20),
                              child: Text(
                                p!.about,
                                style: TextStyle(
                                  fontSize: 20,
                                  height: 1.4,
                                  color: Color.fromARGB(255, 121, 119, 119),
                                ),
                                textAlign: TextAlign.start,
                              ),
                              width:
                                  (width >= 1175) ? width * 0.6 : width * 0.75,
                              alignment: Alignment.centerLeft,
                            ),
                            Container(
                              child: (width < 1175)
                                  ? Container(
                                      width: width * 0.8,
                                      padding:
                                          EdgeInsets.only(left: 20, top: 20),
                                      child: showIconsHorizontal(),
                                    )
                                  : Container(),
                            )
                          ],
                        ),
                      ),
                      //social media
                      Container(
                        child: (width >= 1175)
                            ? Container(
                                width: width * 0.2,
                                padding: EdgeInsets.only(left: 20, top: 20),
                                child: showIconsVertical(height * 0.3),
                              )
                            : Container(),
                      )
                    ],
                  ),
                );
              } else
                return Container(
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: (width >= 1175) ? width * 0.6 : width * 0.75,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
            },
          );
  }

  Stack buildTop(double width, double height) {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 4;
    return Stack(
      alignment: Alignment.centerLeft,
      clipBehavior: Clip.none,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage(width)),
        Positioned(
          top: top,
          left: 35,
          child: Row(
            children: [
              buildProfileImage(),
              (width >= 1175)
                  ? Container(
                      width: width * 0.3,
                      height: height,
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      padding: EdgeInsets.only(left: 10, top: 40),
                      child: nameAndRole(),
                    )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCoverImage(double width) => Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            p!.department_image,
            width: width * 0.6,
            height: coverHeight,
            fit: BoxFit.fitWidth,
          ),
        ),
      );

  Widget buildProfileImage() => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(profileImageEdgeRadius),
            topRight: Radius.circular(profileImageEdgeRadius),
            bottomLeft: Radius.circular(profileImageEdgeRadius),
            bottomRight: Radius.circular(profileImageEdgeRadius),
          ),
          border: Border.all(
            width: 5,
            color: Colors.white,
          ),
          image: DecorationImage(image: NetworkImage(p!.image)),
        ),
        width: profileHeight,
        height: profileHeight,
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

  Widget showIconsVertical(double height) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialIcon(FontAwesomeIcons.google),
        const SizedBox(height: 9),
        buildSocialIcon(FontAwesomeIcons.github),
        const SizedBox(height: 9),
        buildSocialIcon(FontAwesomeIcons.twitter),
        const SizedBox(height: 9),
        buildSocialIcon(FontAwesomeIcons.linkedin),
        const SizedBox(height: 9),
        buildSocialIcon(FontAwesomeIcons.apple),
        const SizedBox(height: 9),
        buildSocialIcon(FontAwesomeIcons.microsoft),
        const SizedBox(height: 9),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(child: SizedBox(height: height)),
              Text(
                'Learn more at',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                child: Text(
                  'pantherauth.gr',
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 103, 145),
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  final url = Uri(
                    scheme: 'https',
                    host: 'pantherauth.gr',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget showIconsHorizontal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          //mainAxisSize: MainAxisSize.max,
          //crossAxisAlignment: CrossAxisAlignment.start,
          //mainAxisAlignment: MainAxisAlignment.center,
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
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Text(
                'Learn more at',
                style: TextStyle(fontSize: 15),
              ),
              TextButton(
                child: Text(
                  'pantherauth.gr',
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 103, 145),
                    fontSize: 20,
                  ),
                ),
                onPressed: () async {
                  final url = Uri(
                    scheme: 'https',
                    host: 'pantherauth.gr',
                  );
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget siteButton(
    double width,
  ) =>
      Container(
        //color: Colors.black,
        width: width * 0.2,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            //SizedBox(
            //  height: MediaQuery.of(context).size.height * 0.8,
            //),

            Text(
              'Learn more at',
              style: TextStyle(fontSize: 15),
            ),
            TextButton(
              child: Text(
                'pantherauth.gr',
                style: TextStyle(
                  color: Color.fromARGB(255, 6, 103, 145),
                  fontSize: 20,
                ),
              ),
              onPressed: () => launchUrl(
                Uri.parse('pantherauth.gr'),
              ),
            ),
          ],
        ),
      );

  Widget nameAndRole() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.yellow,
            child: Text(
              p!.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            child: Text(
              p!.role,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );
}
