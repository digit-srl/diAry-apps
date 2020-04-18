import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class MapBottomsheetInfoBox extends StatelessWidget {
  List<Widget> children;

  MapBottomsheetInfoBox({this.children});

  @override
  Widget build(BuildContext context) {
    // adds dividers as first and last element
    children.insert(0, Divider(height: 1));
    children.add(Divider(height: 1));

    return Container(
    color: Theme.of(context).cardTheme.color,
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    )
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

class MapBottomsheetHeader extends StatelessWidget {
  Widget child;
  double horizontalPadding;

  MapBottomsheetHeader({this.child, this.horizontalPadding = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        height: 80,
        child: child
    );
  }
}

class MapBottomsheetFooter extends StatelessWidget {
  List<GenericButton> buttons;

  MapBottomsheetFooter({this.buttons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
