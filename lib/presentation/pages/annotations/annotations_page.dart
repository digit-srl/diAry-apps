import 'package:diary/application/annotation_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:diary/application/root_elevation_notifier.dart';
import 'package:diary/domain/entities/annotation.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/presentation/widgets/calendar_button.dart';
import 'package:diary/presentation/widgets/custom_icons_icons.dart';
import 'package:diary/presentation/widgets/main_fab_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:diary/utils/extensions.dart';
import 'package:provider/provider.dart';

class AnnotationsPage extends StatefulWidget {
  @override
  _AnnotationsPageState createState() => _AnnotationsPageState();
}

class _AnnotationsPageState extends State<AnnotationsPage> {
  DateFormat format = DateFormat('HH : mm');

  ScrollController _controller;
  final double elevationOn = 4;
  final double elevationOff = 0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    Provider.of<RootElevationNotifier>(context, listen: false).changeElevationIfDifferent(2, 0);
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? elevationOn : elevationOff;
    Provider.of<RootElevationNotifier>(context, listen: false).changeElevationIfDifferent(2, newElevation);
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
                  return Center(
                    child: Text('Nessuna annotazione'),
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
                        annotation.title,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      leading: Icon(Icons.bookmark_border),
                      onTap: () {},
                      trailing: IconButton(
                          icon: Icon(CustomIcons.trash_can_outline),
                          color: accentColor,
                          onPressed: () {
                            GenericUtils.ask(context,
                                'Sicuro di volere eliminare questa annotazione?',
                                () {
                              context
                                  .read<AnnotationNotifier>()
                                  .removeAnnotation(annotation);
                              Navigator.of(context).pop();
                            }, () {});
                          }),
                      subtitle: Text(
                        'Ore: ${format.format(annotation.dateTime)}',
                        style: TextStyle(color: secondaryText),
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
