import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateTask extends StatelessWidget {
  const CreateTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Text(
        "Note #2",
        //'Tuesday 15 • 4.20pm',
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
  }
}
