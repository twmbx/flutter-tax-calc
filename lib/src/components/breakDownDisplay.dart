import 'package:flutter/material.dart';

class BreakDownDisplay extends StatelessWidget {
  final String amount;
  final String title;
  final String icon;
  final String iconLabel;

  BreakDownDisplay({this.amount, this.title, this.icon, this.iconLabel});

  Widget build(context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ImageIcon(
              AssetImage(icon),
              color: Colors.deepPurple,
              size: 26.0,
              semanticLabel: iconLabel,
            ),
            SizedBox(width: 8.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.0),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: Text(
              'ZMW $amount',
              style: TextStyle(
                  fontFamily: 'Assistant',
                  fontWeight: FontWeight.w400,
                  fontSize: 25),
            ),
          ),
        ),
      ],
    );
  }
}
