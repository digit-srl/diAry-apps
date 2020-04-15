import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diary/utils/extensions.dart';

class AnnotationsPage extends StatefulWidget {
  @override
  _AnnotationsPageState createState() => _AnnotationsPageState();
}

class _AnnotationsPageState extends State<AnnotationsPage> {
  DateFormat dateFormat = DateFormat('HH:mm');

  ScrollController _controller;
  final double elevationOn = 4;
  final double elevationOff = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    Provider.of<RootElevationNotifier>(context, listen: false)
        .changeElevationIfDifferent(2, 0);
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? elevationOn : elevationOff;
    Provider.of<RootElevationNotifier>(context, listen: false)
        .changeElevationIfDifferent(2, newElevation);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StateNotifierBuilder<DateState>(
        stateNotifier: context.watch<DateNotifier>(),
        builder: (BuildContext context, dateState, Widget child) {
          return ValueListenableBuilder(
            valueListenable: Hive.box<Annotation>('annotations').listenable(),
            builder:
                (BuildContext context, Box<Annotation> value, Widget child) {
              final annotations = value.values
                  .where((annotation) =>
                      annotation.dateTime.isSameDay(dateState.selectedDate))
                  .toList();
              if (annotations.isEmpty) {
                return Container(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          CustomIcons.bookmark_outline,
                          color: Theme.of(context).textTheme.body1.color,
                          size: 60,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Nessuna annotazione presente per questa giornata.',
                          style: Theme.of(context).textTheme.body1,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                // draw below statusbar and appbar
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight),
                itemCount: annotations.length,
                controller: _controller,

                itemBuilder: (context, index) {
                  final annotation = annotations[index];
                  return ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      annotation?.title ?? 'Errore',
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    leading: Icon(
                      Icons.bookmark_border,
                      color: Theme.of(context).textTheme.body1.color,
                    ),
                    onTap: () {},
                    trailing: IconButton(
                        color: Theme.of(context).iconTheme.color,
                        icon: Icon(CustomIcons.trash_can_outline),
                        onPressed: () {
                          Alerts.showAlertWithPosNegActions(
                              context,
                              "Elimina annotazione",
                              "Sei sicuro di voler eliminare questa annotazione?",
                              "Sì, elimina", () {
                            Provider.of<AnnotationNotifier>(
                                context,
                                listen: false
                            ).removeAnnotation(annotation);
                          });
                        }),
                    subtitle: Text(
                      'Ore: ${dateFormat.format(annotation.dateTime)}',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              );
            },
          );
        },
      ),
    );
  }
}
