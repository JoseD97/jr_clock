import 'package:flutter/material.dart';

// Define el diseño del main body

class MainBody extends StatelessWidget {
  final Widget child;
  const MainBody({Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(5),
      //height: size.height,
      width: size.width,
      decoration: _buildBoxDecorationBody(),
      child: this.child,
    );
  }


  BoxDecoration _buildBoxDecorationBody() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),

    );
  }
}
