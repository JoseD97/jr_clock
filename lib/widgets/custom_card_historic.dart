import 'package:flutter/material.dart';

class CustomCardHistoric extends StatelessWidget {

  final String day;
  final String month;
  final String year;
  final String hourIn;
  final String hourOut;
  final String locationIn;
  final String locationOut;

  const CustomCardHistoric({
    Key? key,
    required this.day,
    required this.month,
    required this.year,
    required this.locationIn,
    required this.hourIn,
    required this.hourOut,
    required this.locationOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size =  MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      height: 75,
      padding: const EdgeInsets.all(10),
      decoration: _boxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Date
          Text('$day/$month/$year', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

          SizedBox(width: 20,),

          // Hout in/out
          SizedBox(
            height: 50,
            width: 70,
            child: Row(
              children: [
                Column(
                  children: const [
                    Icon(Icons.arrow_forward_outlined, color: Colors.green,),
                    Icon(Icons.arrow_back_outlined, color: Colors.redAccent,),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(hourIn),
                    const SizedBox(height: 7),
                    Text(hourOut),
                  ],
                ),
              ],
            ),
          ),

          // Location in/out
          Expanded(
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  Column(
                    children: const [
                      Icon(Icons.location_on, color: Colors.green,),
                      Icon(Icons.location_on, color: Colors.redAccent,),
                    ],
                  ),

                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(locationIn, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Text(locationOut, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }



  Row _hourInOut() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        Column(
          children: const [
            Icon(Icons.arrow_forward_outlined, color: Colors.green,),
            Icon(Icons.arrow_back_outlined, color: Colors.redAccent,),
          ],
        ),
        Column(
          children: [
            Text(hourIn),
            const SizedBox(height: 10),
            Text(hourOut),
          ],
        ),
      ]
    );
  }


  Row _locationInOut() {
    return Row(
      children:[

      ]
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

