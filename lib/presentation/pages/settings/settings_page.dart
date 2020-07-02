import 'dart:io';

import 'package:diary/application/wom_pocket_notifier.dart';
import 'package:diary/domain/entities/call_to_action_source.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:diary/utils/generic_utils.dart';
import 'package:diary/utils/import_export_utils.dart';
import 'package:diary/utils/permissions_utils.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store_redirect/store_redirect.dart';
import '../../../utils/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:provider/provider.dart';
import '../intro_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<SettingItem> items;
  List<SettingItem> utils;
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
        CustomIcons.database_export,
        'Esporta i dati degli spostamenti',
        'Salva in locale tutti i dati relativi agli spostamenti effettuati. '
            'Puoi scegliere quale formato di esportazione utilizzare, tra JSON '
            'e CSV.',
        onTap: () => ImportExportUtils.exportAllData(context),
      ),
      if (Platform.isAndroid)
        SettingItem(
          CustomIcons.flip_to_back,
          'Abilita l\'esecuzione in background',
          'Alcuni produttori di smartphone non consentono '
              'alle applicazioni di essere eseguite adeguatamente '
              'in background, rendendo il rilevamento poco preciso. '
              'Con questo permesso, WOM diAry può risolvere '
              'tale inconveniente.',
          onTap: () => requestIgnoreBatteryOptimization(),
        ),
      SettingItem(
        CustomIcons.playlist_remove,
        'Blacklist Call To Action',
        'Le fonti dalle quali non desideri più ricevere Call To Action vengono '
            'visualizzate all\'interno di questa schermata. Questa permette '
            'di gestirle, ed eventualmente riabilitarle.',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CallToActionManagerPage(),
          ),
        ),
      ),
    ];

    utils = [
      SettingItem(CustomIcons.diary_logo, 'WOM diAry - digital Arianna',
          'Scopri di più', onTap: () {
        GenericUtils.launchURL('https://wom.social/diary');
      }),
      SettingItem(CustomIcons.pocket_logo, 'WOM Pocket',
          '${context.read<WomPocketNotifier>().isInstalled ? 'WOM Pocket correttamente installato' : 'WOM Pocket assente, premi per installare'}',
          onTap: () {}),
      SettingItem(CustomIcons.wom_logo, 'Piattaforma WOM',
          'Scopri cos\'è la piattaforma WOM', onTap: () {
        GenericUtils.launchURL('https://wom.social');
      }),
      SettingItem(
        Icons.help_outline,
        'Tutorial',
        'Visualizza il tutorial iniziale.',
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => IntroPage(
                      fromSettings: true,
                    )),
          )
        },
      ),
      SettingItem(
          CustomIcons.account_multiple_outline,
          'Su di noi...',
          'L\'app è sviluppata dall\'Università di Urbino e da Digit, srl '
              'innovativa, società benefit. Scopri di più.',
          enabled: true, onTap: () {
        GenericUtils.launchURL('https://digit.srl');
      }),

      SettingItem(
        CustomIcons.shield_account_outline,
        'Privacy Policy',
        'La privacy è un tema fondamentale per WOM diAry. Scopri in che modo '
            'questa viene tutelata dall\'app.',
        enabled: true,
        onTap: () {
          GenericUtils.launchURL(
              'https://digit.srl/privacy/diary-privacy-policy/');
        },
      ),
      // SettingItem(Icons.info_outline, 'Terms of service', null, enabled: false),
    ];

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  final titleStyle = TextStyle(fontWeight: FontWeight.w600);

  final titlePadding = const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0);
  // Vital for identifying our FocusDetector when a rebuild occurs.
  final Key _focusDetectorKey = UniqueKey();
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      key: _focusDetectorKey,
      onFocusGained: () async {
        final isPocketInstalled =
            await context.read<WomPocketNotifier>().checkIfPocketIsInstalled();
        setState(() {
          if (isPocketInstalled) {
            utils[1].subtitle = 'WOM Pocket correttamente installato';
            utils[1].onTap = () {};
          } else {
            utils[1].subtitle = 'WOM Pocket assente, premi per installare';
            utils[1].onTap = () {
              StoreRedirect.redirect(
                  androidAppId: 'social.wom.pocket', iOSAppId: "1466969163");
            };
          }
        });
      },
      child: Scaffold(
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
                  'Informazioni',
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
              SizedBox(
                height: 16,
              )
            ],
          ),
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
          utils[0].title = 'WOM diAry - digital Arianna v. $version';
        }
      });
    });
  }
}

class SettingItem {
  final IconData iconData;
  String title;
  String subtitle;
  final bool enabled;
  Function onTap;
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

class CallToActionManagerPage extends StatefulWidget {
  @override
  _CallToActionManagerPageState createState() =>
      _CallToActionManagerPageState();
}

class _CallToActionManagerPageState extends State<CallToActionManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call To Action Black List'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<CallToActionSource>('blackList').listenable(),
        builder: (BuildContext context, Box<CallToActionSource> value,
            Widget child) {
          final list = value.values.toList();
          if (list.isEmpty) {
            return Center(child: Text('Nessuna sorgente nella black list'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      Alert(
                        context: context,
                        style: AlertStyle(isCloseButton: false),
                        title:
                            'Vuoi rimuovere ${list[index].sourceName} dalla black list e tornare a ricevere le sue call to action?',
                        buttons: [
                          DialogButton(
                            child: Text('Annulla'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          DialogButton(
                            child: Text('Si'),
                            onPressed: () {
                              value.deleteAt(index);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ).show();
                    }),
                title: Text(list[index].sourceName ?? '-'),
                subtitle: Text(list[index].sourceDesc ?? '-'),
              );
            },
          );
        },
      ),
    );
  }
}
