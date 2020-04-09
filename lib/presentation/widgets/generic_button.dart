import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class GenericButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool withBorder;
  final Color color;

  const GenericButton(
      {Key key,
      @required this.text,
      @required this.onPressed,
      this.withBorder = true,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return withBorder ? RaisedButton(
      color: color ?? accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      onPressed: onPressed,
      hoverColor: Colors.grey,
      splashColor:Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: AutoSizeText(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: buttonStyle,
      ),
    )

        : FlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      onPressed: onPressed,
      hoverColor: Colors.white,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(16.0),
            ),
      child: AutoSizeText(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
          style: buttonStyle.copyWith(color: accentColor),
      ),
    );
  }
}
