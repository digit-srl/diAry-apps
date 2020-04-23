import 'dart:io';
import 'package:diary/domain/entities/location.dart';
import 'package:diary/utils/alerts.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/import_export_utils.dart';
import 'package:diary/utils/logger.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:diary/application/location_notifier.dart';
import 'package:diary/application/date_notifier.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';

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
  String version = '';

  @override
  void initState() {
    super.initState();
    readVersion();
    items = [
      SettingItem(
        Icons.file_download,
        'Exporta i dati degli spostamenti',
        'Salva in locale i dati relativi agli spostamenti effettuati. Puoi decidere periodo e formato di esportazione.',
        onTap: exportJson,
      ),
      SettingItem(Icons.gps_fixed, 'Calibra Sensori',
          'Utile per per rendere più precise le rilevazioni dell\'accelerometro e del GPS.',
          enabled: false),
      SettingItem(CustomIcons.hospital_box_outline, 'Allerta sanitaria:',
          'Incrocia i dati che hai raccolto con le segnalazioni delle autorità sanitarie',
          enabled: false),
    ];

    utils = [
      SettingItem(null, 'diAry - digital Arianna',
          'Premi per visualizzare il changelog',
          enabled: false, customImageIconAsset: 'assets/diary_logo.png'),
      SettingItem(Icons.bug_report, 'Segnala un bug',
          'Notifica un problema al team di sviluppo tramite mail.',
          enabled: false),
      SettingItem(Icons.star, 'Valutaci sullo store!',
          'Diamo molto peso al giudizio e alle valutazioni degli utenti, e facciamo sempre il possibile per renderle positive.',
          enabled: false),
      SettingItem(Icons.supervised_user_circle, 'Su di noi...',
          'L\'app è sviluppata dall\'Università di Urbino e da Digit, srl innovativa, società benefit. Scopri di più',
          enabled: false),
    ];

    legals = [
      SettingItem(Icons.info_outline, 'Terms of service', null, enabled: false),
      SettingItem(Icons.info_outline, 'Privacy Policy', null, enabled: false),
      SettingItem(Icons.info_outline, 'Licence open source', null,
          enabled: false),
    ];
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  final titleStyle = TextStyle(fontWeight: FontWeight.w600);

  final titlePadding = const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Impostazioni',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
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
                leading: Icon(item.iconData,
                    color: item.enabled
                        ? Theme.of(context).iconTheme.color
                        : secondaryText),
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      color: item.enabled
                          ? Theme.of(context).textTheme.subhead.color
                          : secondaryText),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.body1.copyWith(
                      color: item.enabled
                          ? Theme.of(context).textTheme.body1.color
                          : secondaryText),
                ),
                onTap: item.onTap,
              ),
              items.indexOf(item) == items.length - 1
                  ? Container()
                  : Divider(
                      indent: 72,
                      endIndent: 16,
                    ),
            ],
            Padding(
              padding: titlePadding,
              child: Text(
                'Informazioni utili',
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            for (SettingItem item in utils) ...[
              ListTile(
                leading: item.iconData != null
                    ? Icon(
                        item.iconData,
                        color: item.enabled
                            ? Theme.of(context).iconTheme.color
                            : secondaryText,
                      )
                    : Image.asset(
                        item.customImageIconAsset,
                        color: item.enabled
                            ? Theme.of(context).iconTheme.color
                            : secondaryText,
                        width: 24,
                      ),
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      color: item.enabled
                          ? Theme.of(context).textTheme.subhead.color
                          : secondaryText),
                ),
                subtitle: Text(
                  item.subtitle,
                  style: Theme.of(context).textTheme.body1.copyWith(
                      color: item.enabled
                          ? Theme.of(context).textTheme.body1.color
                          : secondaryText),
                ),
                onTap: item.onTap,
              ),
              utils.indexOf(item) == utils.length - 1
                  ? Container()
                  : Divider(
                      indent: 72,
                      endIndent: 16,
                    ),
            ],
            Padding(
              padding: titlePadding,
              child: Text(
                'Informazioni Legali',
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            for (SettingItem item in legals) ...[
              ListTile(
                leading: Icon(
                  item.iconData,
                  color: item.enabled
                      ? Theme.of(context).iconTheme.color
                      : secondaryText,
                ),
                title: Text(
                  item.title,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      color: item.enabled
                          ? Theme.of(context).textTheme.subhead.color
                          : secondaryText),
                ),
                onTap: item.onTap,
              ),
              legals.indexOf(item) == legals.length - 1
                  ? Container()
                  : Divider(
                      indent: 72,
                      endIndent: 16,
                    ),
            ],
          ],
        ),
      ),
    );
  }

  exportJson() async {
    PermissionStatus permissionStatus = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    logger.i(permissionStatus);
    if (permissionStatus == PermissionStatus.neverAskAgain) {
      Alerts.showAlertWithPosNegActions(
          context,
          "Attenzione",
          "In percedenza hai disabilitato il permesso di archiviazione. E' "
              "necessario abilitarlo manualmente dalle impostazioni di sistema.",
          "Vai a Impostazioni", () {
        PermissionHandler().openAppSettings();
      });
      return;
    } else if (permissionStatus != PermissionStatus.granted) {
      final permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return;
      }
    }

    final currentDate =
        Provider.of<DateState>(context, listen: false).selectedDate;

    final List<Location> locations =
        Provider.of<LocationNotifier>(context, listen: false)
            .getCurrentDayLocations;

    final List<File> files =
        await ImportExportUtils.saveFilesOnLocalStorage(locations, currentDate);
    if (files == null || files.isEmpty) return;
    final csvFile = files[0];
    final jsonFile = files[1];
    final csvPath = csvFile.path;
    final jsonPath = jsonFile.path;

    Alerts.showAlertWithTwoActions(
        context,
        "Esporta dati",
        "Seleziona il formato per l'esportazione dei dati.",
        "CSV",
        () {
          Share.file('Il mio file CSV', csvPath.split('/').last,
              csvFile.readAsBytesSync(), 'application/*');
        },
        "JSON",
        () {
          Share.file('Il mio file JSON', jsonPath.split('/').last,
              jsonFile.readAsBytesSync(), 'application/*');
        });
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

  void readVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (mounted) {
          version = packageInfo.version;
          utils[0].title = 'diAry - digital Arianna v. $version';
        }
      });
    });
  }
}

class SettingItem {
  final IconData iconData;
  String title;
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
