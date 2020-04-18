import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

/*
 * Implements a standard behavior and styling for all bottom sheets inside the
 * app, using the same custom style over sliding_sheet. It provides some
 * standardized bottom sheet templates.
 */
class BottomSheets {

  // generic alert that shows some sort of information in a column. It takes
  // the children of the column as a content. It has not a fixed height, that
  // is adapted to the content
  static showInfoBottomSheet(BuildContext context, Widget content) async {
    await showSlidingBottomSheet(context, useRootNavigator: true,
        builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        color: Theme.of(context).primaryColor,
        //minHeight: 400,
        duration: Duration(milliseconds: 300),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [SnapSpec.expanded],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (ctx, sheetState) {
          return Container(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: content,
              ),
            ),
          );
        },
      );
    });
  }

  // Bottomsheet for map page. It has a transparent backdrop color and it snaps
  // at 60% of height (useful in pin sheet). It handles header, body and footer.
  static showMapBottomSheet(BuildContext context, Widget header, Widget body, Widget footer) async {
    await showSlidingBottomSheet(
      context,
      useRootNavigator: true,
      builder: (context) {
        return SlidingSheetDialog(
          elevation: 8,
          backdropColor: Colors.transparent,
          cornerRadius: 16,
          color: Theme.of(context).primaryColor,
          duration: Duration(milliseconds: 300),
          snapSpec: const SnapSpec(
            snap: true,
            snappings: [
              SnapSpec.headerFooterSnap,
              0.6,
              1.0,
            ],
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          headerBuilder: (context, state) =>  Material(
            color: Theme.of(context).primaryColor,
            child: header,
          ),
          footerBuilder: (ctx, state) => Material(
            color: Theme.of(context).primaryColor,
            child: footer,
          ),
          builder: (context, state) => Material(
            color: Theme.of(context).cardTheme.color,
            child: body,
          ),
        );
      },
    );
  }

  // shows a bottomsheet with an initial fixed size of 9/10 of the page.
  // Used principally in infoStats.
  static showFullPageBottomSheet(BuildContext context, Widget content) async {
    await showSlidingBottomSheet(
        context,
        useRootNavigator: true,
        builder: (context) {
      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        color: Theme.of(context).primaryColor,
        duration: Duration(milliseconds: 300),
        minHeight: MediaQuery.of(context).size.height * 0.9,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.9],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (ctx, sheetState) {
          return Container(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: content,
              ),
            ),
          );
        },
      );
    });
  }
}

/*
 * Utility object that implements the default format for bottomsheet columns
 */
class StandardBottomSheetColumn extends StatelessWidget {
  List<Widget> children;
  
  StandardBottomSheetColumn({this.children});
      
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
