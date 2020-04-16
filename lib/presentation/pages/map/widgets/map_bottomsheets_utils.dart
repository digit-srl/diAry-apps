import 'package:flutter/material.dart';

class MapBottomsheetInfoBox extends StatelessWidget {
  List<Widget> children;

  MapBottomsheetInfoBox({this.children});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Expanded(
      child: Container(
        decoration: new BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: new BorderRadius.all(Radius.circular(16))),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}

class MapBottomsheetInfoLine extends StatelessWidget {
  final String text;
  final Icon icon;

  MapBottomsheetInfoLine({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 24,
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        ],
      ),
    );
  }
}
