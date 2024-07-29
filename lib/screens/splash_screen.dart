import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/app_setup.dart';
import '../providers/device.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  late Future<bool> session;
  @override
  void initState() {
    super.initState();
    session = checkSession(context);
    _controller = VideoPlayerController.asset('images/loading.mp4')
      ..initialize().then((_) {
        setState(() {});
      })
      ..setVolume(0.0);
    _playVideo();
    _requestPermissions1();

  }


  void _requestPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Allow Notifications"),
            content: Text("Our app would like to send you notifications"),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await AwesomeNotifications()
                      .requestPermissionToSendNotifications();
                },
                child: Text("Allow"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Deny"),
              ),
            ],
          ));
    }
  }
  void _requestPermissions1() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
  }

  // Method to show notification


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo() async {
    _controller.play();
    AppSetup a = Provider.of<AppSetup>(context, listen: false);
    print('v2');
    DeviceManager device = Provider.of<DeviceManager>(context, listen: false);
    if (await session) {
      await Future.value(a.setValuesAuto());
    }
    await Future.delayed(const Duration(seconds: 2));

    Navigator.of(context)
        .pushReplacementNamed(await session ? device.getRoute() : '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       signOut(context);
          //     },
          //     child: Text("Sign Out"),
          //   ),
          // ),
        ],
      ),
    );
  }
}
