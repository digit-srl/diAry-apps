import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import '../../utils/styles.dart';

class GenericButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool withBorder;

  const GenericButton(
      {Key key, this.text, this.onPressed, this.withBorder = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return withBorder ? RaisedButton(
      color: accentColor,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      onPressed: onPressed,
      hoverColor: Colors.grey,
      splashColor:Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(16.0),
      ),
      child: AutoSizeText(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: buttonStyle,
      ),
    )

        : FlatButton(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
