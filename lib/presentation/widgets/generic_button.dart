import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:diary/utils/colors.dart';

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
    return FlatButton(
      color: withBorder ? color ?? accentColor : null,
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      onPressed: onPressed,
//      hoverColor: Colors.white,
      splashColor: withBorder ? Colors.grey : Colors.white,
      shape: withBorder
          ? RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            )
          : null,
      child: AutoSizeText(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style:
            withBorder ? buttonStyle : buttonStyle.copyWith(color: accentColor),
      ),
    );
  }
}
