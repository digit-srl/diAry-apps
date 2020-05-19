import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/import_export_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import '../../../utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
        'Salva in locale tutti i dati relativi agli spostamenti effettuati. Puoi decidere il formato di esportazione.',
        onTap: () => ImportExportUtils.exportAllData(context),
      ),
//      SettingItem(Icons.gps_fixed, 'Calibra Sensori',
//          'Utile per per rendere più precise le rilevazioni dell\'accelerometro e del GPS.',
//          enabled: false),
//      SettingItem(CustomIcons.hospital_box_outline, 'Allerta sanitaria:',
//          'Incrocia i dati che hai raccolto con le segnalazioni delle autorità sanitarie',
//          enabled: false),
    ];

    utils = [
      SettingItem(null, 'diAry - digital Arianna',
          'Premi per visualizzare il changelog',
          enabled: true,
          customImageIconAsset: 'assets/diary_logo.png', onTap: () {
        GenericUtils.launchURL('https://covid19app.uniurb.it/category/news/');
      }),
//      SettingItem(Icons.bug_report, 'Segnala un bug',
//          'Notifica un problema al team di sviluppo tramite mail.',
//          enabled: false),
//      SettingItem(Icons.star, 'Valutaci sullo store!',
//          'Diamo molto peso al giudizio e alle valutazioni degli utenti, e facciamo sempre il possibile per renderle positive.',
//          enabled: false),
      SettingItem(Icons.supervised_user_circle, 'Su di noi...',
          'L\'app è sviluppata dall\'Università di Urbino e da Digit, srl innovativa, società benefit. Scopri di più',
          enabled: true, onTap: () {
        GenericUtils.launchURL('https://digit.srl');
      }),
    ];

    legals = [
//      SettingItem(Icons.info_outline, 'Terms of service', null, enabled: false),
      SettingItem(Icons.info_outline, 'Privacy Policy', null, enabled: true,
          onTap: () {
        GenericUtils.launchURL(
          'https://covid19app.uniurb.it/privacy-policy/',
        );
//        BottomSheets.showFullPageBottomSheet(
//            context,
//            MyWebView(
//              url: 'https://covid19app.uniurb.it/privacy-policy/',
//            ));
      }),
//      SettingItem(Icons.info_outline, 'Licence open source', null,
//          enabled: false),
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

//  requestIgnoreBatteryOptimization() async {
//    try {
//      PermissionStatus permissionStatus = await PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.ignoreBatteryOptimizations);
//      print(permissionStatus);
//    } catch (ex) {
//      await PermissionHandler().openAppSettings();
//    }
//  }

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
    _controller?.removeListener(_scrollListener);
    _controller?.dispose();
    super.dispose();
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

class MyWebView extends StatelessWidget {
  final String url;

  const MyWebView({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Container(
        child: WebView(
          initialUrl: url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
