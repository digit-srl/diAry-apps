import 'package:auto_size_text/auto_size_text.dart';
import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:provider/provider.dart';

showAnnotationBottomSheet(Annotation annotation, BuildContext context) async {
  final DateFormat dateFormat = DateFormat('dd MMM yyyy HH:mm');

  await showSlidingBottomSheet(
    context,
    useRootNavigator: true,
    builder: (context) {
      return SlidingSheetDialog(
        backdropColor: Colors.black.withOpacity(0.0),
        elevation: 8,
        cornerRadius: 16,
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.all(16.0),
        //minHeight: 400,
        duration: Duration(milliseconds: 300),
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.7, 1.0],
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        builder: (ctx, sheetState) {
          return Container(
            child: Material(
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            //isHome ? CustomIcons.home_outline : CustomIcons.map_marker_outline,
                            CustomIcons.bookmark_outline,
                            color: Theme.of(context).primaryColor,
                            size: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: AutoSizeText(
                              "Annotazione",
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headline,
                            )),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                        tooltip: "Modifica (coming soon!)",
                      ),
                      IconButton(
                        icon: Icon(CustomIcons.trash_can_outline),
                        tooltip: "Elimina",
                        onPressed: () async {
                          Alerts.showAlertWithPosNegActions(
                              context,
                              "Elimina annotazione",
                              "Sei sicuro di voler eliminare questa annotazione?",
                              "Sì, elimina", () {
                            Provider.of<AnnotationNotifier>(context,
                                listen: false)
                                .removeAnnotation(annotation);
                          });
                          // chiude il bottomsheet
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.message,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          annotation.title,
                          style: Theme.of(context).textTheme.body1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.gps_fixed,
                        ),
                      ),
                      Text(
                        'Lat: ${annotation.latitude.toStringAsFixed(2)} Long: ${annotation.longitude.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
                        child: Icon(
                          Icons.access_time,
                        ),
                      ),
                      Text(
                        dateFormat.format(annotation.dateTime),
                        style: Theme.of(context).textTheme.body1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
