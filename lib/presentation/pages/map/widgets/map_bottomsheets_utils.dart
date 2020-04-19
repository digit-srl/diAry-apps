import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

/*
 * The module collects common widgets between map bottom sheets.
 */

/*
 * The main sheet body component, including a list of MapBottomsheetInfoLine.
 */
class MapBottomsheetInfoBox extends StatelessWidget {
  List<Widget> children;

  MapBottomsheetInfoBox({this.children});

  @override
  Widget build(BuildContext context) {
    if (children == null)
      children = <Widget>[];

    // adds dividers as first and last element
    children.insert(0, Divider(height: 1));
    children.add(Divider(height: 1));

    return Container(
        color: Theme.of(context).cardTheme.color,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ));
  }
}

/*
 * An information line inside the sheet body, with an image and a text.
 * Built in a way that preserves text responsiveness.
 */
class MapBottomsheetInfoLine extends StatelessWidget {
  final String text;
  final Icon icon;

  MapBottomsheetInfoLine({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 16, 8),
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

/*
 * A MapBottomsheetInfoLine with a fixed height (text do not expands, bot stays
 * in a line with AutoSizeText
 */
class MapBottomsheetFixedInfoLine extends StatelessWidget {
  final String text;
  final Icon icon;

  MapBottomsheetFixedInfoLine({this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 16, 8),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 24,
          ),
          Expanded(
            child: AutoSizeText(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.body1,
            ),
          ),
        ],
      ),
    );
  }
}

/*
 * The main Icon of the header, with a colored circle around.
 */
class MapBottomsheetHeaderIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;

  MapBottomsheetHeaderIcon(this.iconData, {this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
    );
  }
}

/*
 * Component that represents the standard header structure. If horizontal
 * padding is not specified, it is considered default 16.
 */
class MapBottomsheetHeader extends StatelessWidget {
  Widget child;
  double horizontalPadding;

  MapBottomsheetHeader({this.child, this.horizontalPadding = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        height: 80,
        child: child);
  }
}

/*
 * Component that represents the standard footer structure.
 */
class MapBottomsheetFooter extends StatelessWidget {
  final List<GenericButton> buttons;
  final bool showExpandButton;

  MapBottomsheetFooter({this.buttons, this.showExpandButton = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (showExpandButton)
            IconButton(
              icon: Icon(Icons.keyboard_arrow_up),
              tooltip: "Maggiori informazioni",
              onPressed: () {
                if (SheetController.of(context).state.isExpanded)
                  SheetController.of(context).collapse();
                else
                  SheetController.of(context).expand();
              },
            ),
          Spacer(),
          ButtonBar(children: buttons)
        ],
      ),
    );
  }
}

/*
 * Used to show an empty body in bottomsheet. The height must be set in the
 * sheets, so it is set to a mesaure smaller than one pixel.
 */
class MapBottomsheetEmptyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 0.1);
  }
}
