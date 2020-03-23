import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/styles.dart';

class GenericCard extends StatelessWidget {
  final String title;
  final String description;
  final Widget bottomWidget;
  final Icon icon;
  final IconData iconData;
  final Color iconColor;
  final bool enabled;

  const GenericCard(
      {Key key,
      this.title,
      this.description,
      this.bottomWidget,
      this.icon,
      this.iconData,
      this.iconColor,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: enabled ? baseCard : activatedCard,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: LayoutBuilder(
                    builder: (ctx, constraint) {
                      if (iconData != null) {
                        return Icon(
                          iconData,
                          color: iconColor,
                          size: constraint.maxWidth,
                        );
                      }
                      return Image.asset('assets/diary_logo.png');
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 8,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AutoSizeText(title,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: titleCardStyle),
                      SizedBox(height: 10),
                      AutoSizeText(
                        description,
                        maxLines: 2,
                        style: enabled ? secondaryStyleDark : secondaryStyle,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(),
              ),
              Flexible(flex: 8, child: bottomWidget),
            ],
          ),
        ],
      ),
    );
  }
}
