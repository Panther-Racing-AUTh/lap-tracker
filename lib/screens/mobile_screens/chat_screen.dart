import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/names.dart';
import 'package:flutter_complete_guide/widgets/chat_widget.dart';
import '../../widgets/main_appbar.dart';

class ChatScreen extends StatelessWidget {
  //static const String routeName = '/chat';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          text: chat,
          context: context,
        ),
        body: Container());
  }
}
