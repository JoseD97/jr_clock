import 'package:flutter/material.dart';
import '../services/services.dart';


class ProfileImage extends StatelessWidget {

  final double height;
  final double width;

  const ProfileImage({Key? key,
    required this.height,
    required this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ClockInFirestore.getImageUrl(),
      builder: (BuildContext context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError) {
            return SizedBox(
              height: height,
              width: width,
              child: ClipOval(child: Image.asset('assets/blank-profile.png')));
          }
          // Si llega una URL correcta
          if (snapshot.data != null && snapshot.data != '' ) {
            return ClipOval(
              child: FadeInImage(
                width: width,
                height: height,
                fit: BoxFit.cover,
                placeholder: const AssetImage('assets/blank-profile.png'),
                image: NetworkImage(snapshot.data ?? ''),
              ),
            );
          }
          return SizedBox(
              height: height,
              width: width,
              child: ClipOval(child: Image.asset('assets/blank-profile.png')));
        }
        else {
          return SizedBox(height: height, width: width);
        }
      },
    );
  }
}