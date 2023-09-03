import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForecast(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 7,
      shadowColor: Colors.transparent,
      color: Colors.grey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4,),
          SizedBox(
              width: 100,
              child: Text(time,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  ))),
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 55,
          ),
          const SizedBox(height: 8),
          SizedBox(
              width:
                  100, //120 i already did for Time above hence its not required now
              child: Text("$temp C",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ))),
        ],
      ),
    );
  }
}
