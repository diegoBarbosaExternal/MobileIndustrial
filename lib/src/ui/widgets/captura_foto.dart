import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CapturaFoto extends StatefulWidget{

  final CameraDescription camera;

  const CapturaFoto({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  CapturaFotoState createState() => CapturaFotoState();
}

class CapturaFotoState extends State<CapturaFoto>{
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState(){
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


  }
}

