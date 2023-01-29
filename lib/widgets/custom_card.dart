import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final Widget child;

  const CustomCard({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: this.child,
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const[
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 10,
          offset: Offset(0, 5),
        ),
      ],
    );
  }
}

