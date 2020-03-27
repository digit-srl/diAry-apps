import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';

import '../../../../utils/styles.dart';

class GenericCard extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget> bottomButtons;
  final Icon icon;
  final IconData iconData;
  final Color iconColor;
  final bool enabled;

  const GenericCard(
      {Key key,
      this.title,
      this.description,
      this.bottomButtons,
      this.icon,
      this.iconData,
      this.iconColor,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16,8,16,8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: enabled ? baseCard : deactivatedCard,

      child: Padding(
        padding: const EdgeInsets.fromLTRB(8,16,8,0),
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
                        SizedBox(height: 8),
                        AutoSizeText(
                          description,
                          maxLines: 2,
                          style: enabled ? secondaryStyle : secondaryStyleDark,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
             ButtonBar(
              children:
                  // modificato in maniera tale da prendere più flessibilmente una lista di buttons
              bottomButtons == null ? <Widget>[] : bottomButtons,
            )
          ],
        ),
      ),
    );
  }
}
