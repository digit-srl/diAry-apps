import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/root/date_notifier.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_extend/share_extend.dart';
import 'package:provider/provider.dart';
import '../../../colors.dart';
import '../../../map_to_csv.dart';
import 'package:diary/extensions.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingItem> items;
  List<SettingItem> utils;
  List<SettingItem> legals;
  final double targetElevation = 3;
  double _elevation = 0;
  ScrollController _controller;

  @override
  void initState() {
    super.initState();

    items = [
      SettingItem(
        Icons.file_download,
        'Exporta CSV spostamenti',
        'Salva in locale i dati relativi agli spostamenti effettuati. Puoi decidere periodo e formato di esportazione.',
        onTap: exportJson,
      ),
      SettingItem(Icons.gps_fixed, 'Calibra Sensori',
          'Utile per per rendere più precise le rilevazioni dell\'accelerometro e del GPS.'),
      SettingItem(Icons.local_hospital, 'Allerta sanitaria:',
          'Incrocia i dati che hai raccolto con le segnalazioni delle autorità sanitarie',
          enabled: false),
    ];

    utils = [
      SettingItem(null, 'diAry - digital Arianna',
          'Versione 0.0.0. Premi per visualizzare il changelog',
          customImageIconAsset: 'assets/diary_logo.png'),
      SettingItem(Icons.bug_report, 'Segnala un bug',
          'Notifica un problema al team di sviluppo tramite mail.'),
      SettingItem(Icons.star, 'Valutaci sullo store!',
          'Diamo molto peso al giudizio e alle valutazioni degli utenti, e facciamo sempre il possibile per renderle positive.'),
      SettingItem(Icons.supervised_user_circle, 'Su di noi...',
          'L\'app è sviluppata dall\'Università di Urbino e da Digit, srl innovativa, società benefit. Scopri di più'),
    ];

    legals = [
      SettingItem(Icons.info_outline, 'Terms of service', null),
      SettingItem(Icons.info_outline, 'Privacy Policy', null),
      SettingItem(Icons.info_outline, 'Licence open source', null),
    ];
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  final titleStyle = TextStyle(fontWeight: FontWeight.w600);

  final titlePadding = const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Impostazioni',
          style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: _elevation,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            for (SettingItem item in items) ...[
              ListTile(
                leading: Icon(
                  item.iconData,
                  color: accentColor,
                ),
                title: Text(
                  item.title,
                  style: titleStyle.copyWith(
                      color: item.enabled ? Colors.black : secondaryText),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: TextStyle(color: secondaryText),
                ),
                onTap: item.onTap,
              ),
              items.indexOf(item) == items.length - 1
                  ? Container()
                  : Divider(
                      indent: 20,
                    ),
            ],
            Padding(
              padding: titlePadding,
              child: Text(
                'Informazioni utili',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            for (SettingItem item in utils) ...[
              ListTile(
                leading: item.iconData != null
                    ? Icon(
                        item.iconData,
                        color: accentColor,
                      )
                    : Image.asset(
                        item.customImageIconAsset,
                        width: 24,
                      ),
                title: Text(
                  item.title,
                  style: titleStyle,
                ),
                subtitle: Text(
                  item.subtitle,
                  style: TextStyle(color: secondaryText),
                ),
                onTap: item.onTap,
              ),
              utils.indexOf(item) == utils.length - 1
                  ? Container()
                  : Divider(
                      indent: 20,
                    ),
            ],
            Padding(
              padding: titlePadding,
              child: Text(
                'Informazioni Legali',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            for (SettingItem item in legals) ...[
              ListTile(
                leading: Icon(
                  item.iconData,
                  color: accentColor,
                ),
                title: Text(
                  item.title,
                  style: titleStyle,
                ),
                onTap: item.onTap,
              ),
              legals.indexOf(item) == legals.length - 1
                  ? Container()
                  : Divider(
                      indent: 20,
                    ),
            ],
          ],
        ),
      ),
    );
  }

  exportJson() async {
    final currentDate =
        Provider.of<DateState>(context, listen: false).selectedDate;

    final locations = Provider.of<LocationNotifier>(context, listen: false)
        .locationsPerDate[currentDate];
    if (currentDate.isToday()) {
      locations.addAll(
          Provider.of<LocationNotifier>(context, listen: false).liveLocations);
    }
    final File file = await exportCsv(locations, currentDate);
    if (file == null) return;
    final path = file.path;

    Alert(
      context: context,
      title: 'Condividi il file',
      buttons: [
        DialogButton(
          child: Text(
            'CSV',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context);
            ShareExtend.share(path, 'file');
          },
        ),
      ],
    ).show();
  }

  void _scrollListener() {
    double newElevation = _controller.offset > 1 ? targetElevation : 0;
    if (_elevation != newElevation) {
      setState(() {
        _elevation = newElevation;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
  }
}

class SettingItem {
  final IconData iconData;
  final String title;
  final String subtitle;
  final bool enabled;
  final Function onTap;
  final String customImageIconAsset;

  SettingItem(this.iconData, this.title, this.subtitle,
      {this.onTap, this.enabled = true, this.customImageIconAsset})
      : assert(title != null),
        assert(iconData != null ||
            (iconData == null && customImageIconAsset != null));
}
