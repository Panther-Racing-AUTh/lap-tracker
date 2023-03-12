import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/supabase/authentication_functions.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../providers/app_setup.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool session = checkSession();
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();

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

    await Future.delayed(const Duration(seconds: 2));
    AppSetup a = Provider.of<AppSetup>(context, listen: false);
    if (session) a.setRoleAuto();
    Navigator.of(context).pushReplacementNamed(session ? '/main' : '/signin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}
