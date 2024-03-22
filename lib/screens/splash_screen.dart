import 'dart:async';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _playVideo() async {
    _controller.play();
    AppSetup a = Provider.of<AppSetup>(context, listen: false);
    DeviceManager device = Provider.of<DeviceManager>(context, listen: false);
    print("Heloo wor");
    if (await session) {
      print("Heloo wor");
      await Future.value(a.setValuesAuto());
      print("Heloo wor");
    }
    print("Heloo wor");
    await Future.delayed(const Duration(seconds: 1));

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
