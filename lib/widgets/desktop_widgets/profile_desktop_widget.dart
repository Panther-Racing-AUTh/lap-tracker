import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/person.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart' as provider;
import '../../providers/app_setup.dart';
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
  late Future<List> dataFuture;

  @override
  void initState() {
    AppSetup appSetup = provider.Provider.of<AppSetup>(context, listen: false);
    super.initState();
    if (supabase.auth.currentSession != null)
      dataFuture = getUserProfile(id: appSetup.supabase_id);
  }

  int changeIconsLayout = 1400;
  @override
  Widget build(BuildContext context) {
    AppSetup setup = provider.Provider.of<AppSetup>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);

    return (supabase.auth.currentUser == null)
        ? Container(
            height: height,
            child: Center(
              child: Text(
                sign_in_to_see_profile,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          )
        : FutureBuilder<List>(
            future: dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                p = snapshot.data![1];
                final admins = [];
                snapshot.data![0].forEach((element) {
                  admins.add(element['admin_name']['full_name']);
                });

                return Container(
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: (width >= changeIconsLayout)
                        ? width * 0.6
                        : width * 0.75,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (setup.role == 'default')
                        Stack(
                          children: [
                            Container(
                              color: Colors.grey,
                              height: 40,
                            ),
                            VerificationMessage(admins),
                          ],
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: buildTop(width, height * 0.2),
                                ),
                                if (width < changeIconsLayout)
                                  SizedBox(
                                    height: height * 0.01,
                                    child: Container(),
                                  ),
                                if (width < changeIconsLayout)
                                  Container(
                                    padding: EdgeInsets.only(left: 20, top: 20),
                                    child: nameAndRole(),
                                  ),
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
                                  width: (width >= changeIconsLayout)
                                      ? width * 0.6
                                      : width * 0.55,
                                  alignment: Alignment.centerLeft,
                                ),
                                if (width < changeIconsLayout)
                                  Container(
                                    padding: EdgeInsets.only(left: 20, top: 20),
                                    child: showIconsHorizontal(),
                                  )
                              ],
                            ),
                          ),
                          //social media

                          if (width >= changeIconsLayout)
                            Container(
                              width: width * 0.2,
                              padding: EdgeInsets.only(left: 20, top: 20),
                              child: showIconsVertical(height * 0.3),
                            )
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(
                  constraints: BoxConstraints(
                    minHeight: height,
                    minWidth: (width >= changeIconsLayout)
                        ? width * 0.6
                        : width * 0.75,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileImage(),
              (width >= changeIconsLayout)
                  ? Container(
                      width: width * 0.3,
                      height: height * 0.9,
                      constraints: BoxConstraints(
                        minHeight: 130,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
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
                      learn_more_at,
                      style: TextStyle(fontSize: 15),
                    ),
                    CustomWebsiteButton(),
                  ],
                ),
              )
            ],
          ),
        ),
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
                learn_more_at,
                style: TextStyle(fontSize: 15),
              ),
              CustomWebsiteButton()
            ],
          ),
        ),
      ],
    );
  }

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

class CustomWebsiteButton extends StatelessWidget {
  const CustomWebsiteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
    );
  }
}

Widget VerificationMessage(List admins) => Container(
      height: 40,
      color: Colors.grey.withOpacity(0.9),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 20),
              Icon(
                Icons.warning,
                color: Colors.red,
              ),
              Text(
                'Contact an admin to be assigned a role!',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(width: 20),
              Text(
                'Admin(s): ' +
                    admins
                        .toString()
                        .replaceFirst('[', '')
                        .replaceFirst(']', ''),
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ],
      ),
    );
