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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
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

  MapBottomsheetHeader({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
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
          SizedBox(
            width: 16,
          ),
          ButtonBar(children: buttons)
        ],
      ),
    );
  }
}
