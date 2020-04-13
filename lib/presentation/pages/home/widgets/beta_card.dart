import 'package:diary/presentation/pages/logs_page.dart';
import 'package:diary/presentation/pages/slices_page.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../slices_page.dart';
import 'generic_card.dart';

// import necessari pre funzionalità di debug aggiuntive e gps fittizio
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/service_notifier.dart';
import 'package:diary/domain/entities/motion_activity.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;

class BetaCard extends StatefulWidget {
  @override
  _BetaCardState createState() => _BetaCardState();
}

class _BetaCardState extends State<BetaCard> {
  bool isMoving = false;
  String version = "v.0.0.0";

  @override
  void initState() {
    super.initState();
    _readVersion();
  }

  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<MotionActivityState>(
      stateNotifier: context.watch<MotionActivityNotifier>(),
      builder: (BuildContext context, value, Widget child) {
        return GenericCard(
          enabled: true,
          iconData: CustomIcons.flask_outline,
          title: 'diAry ' + version + " Beta",
          description:
          'Scheda mostrata solo ai beta tester. Contiene funzioni per il test.',
          bottomButtons: <Widget>[
            IconButton(
              icon: Icon(Icons.bug_report),
              tooltip: "Log report",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LogsPage(),
                  ),
                );
              },
            ),

            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              tooltip: "Spicchi giornalieri",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TabBarDemo(),
                  ),
                );
              },
            ),

            GenericButton(
              text: "Changelog",
              onPressed: _launchChangelogURL,
            ),
          ],
        );
      },
    );
  }

  _launchChangelogURL() async {
    // todo modify with the specific page at each release
    const url = 'https://covid19app.uniurb.it/category/news/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _readVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (mounted) {
          version = 'v.' + packageInfo.version;
        }
      });
    });
  }
}