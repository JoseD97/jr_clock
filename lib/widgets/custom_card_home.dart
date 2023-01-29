import 'package:flutter/material.dart';

class CustomCardHome extends StatelessWidget {

  final IconData icon;
  final String text;

  const CustomCardHome({
    Key? key,
    required this.icon,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => print('hola'),
      //splashColor: Colors.red,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: _boxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(this.icon),
            Text(this.text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
            const Icon(Icons.arrow_forward_ios),
          ]
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const[
        BoxShadow(
          color: Colors.black12,
          blurRadius: 10,
          spreadRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}

