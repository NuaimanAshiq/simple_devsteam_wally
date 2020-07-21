import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final Image image;
  ImageView(this.image);
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Center(
          child: widget.image,
        ));
  }
}
