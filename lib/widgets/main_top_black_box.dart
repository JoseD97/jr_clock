import 'package:flutter/material.dart';

// Define la estructura del encabezado

class MainTopBlackBox extends StatelessWidget {
  final Widget child;

  const MainTopBlackBox({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: false,
      child: Container(
        width: size.width,
        height: 150,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: this.child,
        ),
      ),
    );
  }
}