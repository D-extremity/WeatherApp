import 'package:flutter/material.dart';

class Additional extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const Additional(
      {super.key,
      required this.icon,
      required this.title,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 6,
        ),
        Icon(
          icon,
          size: 50,
        ),
        const SizedBox(height: 6),
        SizedBox(
            width: 100,
            child: Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontSize: 15,
                ))),
        const SizedBox(height: 4),
        SizedBox(
            width:
                100, //120 i already did for Time above hence its not required now
            child: Text(value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))),
      ],
    );
  }
}
