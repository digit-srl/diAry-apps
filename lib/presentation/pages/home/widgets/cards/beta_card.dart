import 'package:diary/presentation/pages/logs_page.dart';
import 'package:diary/presentation/pages/slices_page.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:diary/application/motion_activity_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:logger_flutter/logger_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../slices_page.dart';
import 'home_generic_card.dart';

/*
 * It shows some features and information show only to beta testers.
 */
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
        return HomeGenericCard(
          enabled: true,
          iconData: CustomIcons.flask_outline,
          title: 'diAry ' + version + " Beta",
          description: 'Scheda mostrata solo ai beta tester. Contiene '
              'funzioni per il test.',
          bottomButtons: <Widget>[
            if (!kReleaseMode)
              IconButton(
                icon: Icon(
                  Icons.bug_report,
                  color: Colors.red,
                ),
                tooltip: "Debug report",
                onPressed: () async {
                  LogConsole.init();
                  var logConsole = LogConsole(
                    showCloseButton: true,
                    dark: true,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) => logConsole),
                  );
                },
              ),
            IconButton(
              icon: Icon(Icons.bug_report),
              tooltip: "Peersistent log report",
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
