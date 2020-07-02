import 'dart:io';

import 'package:diary/application/wom_pocket_notifier.dart';
import 'package:diary/presentation/pages/root/root_page.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/app_theme.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:hive/hive.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';

class IntroPage extends StatefulWidget {
  final bool fromSettings;

  IntroPage({Key key, this.fromSettings = false}) : super(key: key);

  @override
  IntroPageState createState() => new IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  List<Slide> slides = List();
  final Key _focusDetectorKey = UniqueKey();
  bool isPocketInstalled = false;

  @override
  void initState() {
    super.initState();
    isPocketInstalled = context.read<WomPocketNotifier>().isInstalled;
  }

  void onDonePress() async {
    if (widget.fromSettings) {
      Navigator.of(context).pop();
    } else {
      await setToNotFirstTime();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => RootPage()));
    }
  }

  setToNotFirstTime() async {
    await Hive.box('user').put('firstTime', false);
  }

  Slide descriptionSlide;
  @override
  Widget build(BuildContext context) {
    descriptionSlide = Slide(
      maxLineTitle: 10,
      styleTitle:
          Theme.of(context).textTheme.title.copyWith(color: accentColor),
      styleDescription:
          Theme.of(context).textTheme.body1.copyWith(color: accentColor),
      backgroundColor: Colors.white,
      heightImage: 200,
      pathImage: "assets/slide4.png",
      title: "Voucher per impegno sociale",
      widgetDescription: Column(
        children: <Widget>[
          Text(
            "Molte delle azioni individuali generano valore sociale. "
            "Tale valore è quantificato in termini di WOM, speciali voucher inclusi "
            "tra gli strumenti di innovazione sociale digitale della "
            "Commissione Europea.\n"
            "WOM diAry ti segnala le opportunità di riscuotere WOM come riconoscimento del valore delle tue azioni."
            '${!isPocketInstalled ? '\n\nTi consigliamo di installare subito l\'applicazione WOM Pocket per collezionare i tuoi voucher.' : ''}',
            textAlign: TextAlign.center,
            style:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
          ),
          if (!isPocketInstalled)
            GenericButton(
              onPressed: () {
                StoreRedirect.redirect(
                    androidAppId: 'social.wom.pocket', iOSAppId: "1466969163");
              },
              text: 'Installa',
            ),
        ],
      ),
//        description: "Molte delle azioni individuali generano valore sociale. "
//            "Tale valore è quantificato in termini di WOM, speciali voucher inclusi "
//            "tra gli strumenti di innovazione sociale digitale della "
//            "Commissione Europea.\n"
//            "WOM diAry ti segnala le opportunità di riscuotere WOM come riconoscimento del valore delle tue azioni.\n\n"
//            "Ti consigliamo di installare subito l'applicazione WOM Pocket per collezionare i tuoi voucher.",
    );

    slides = [
      Slide(
        maxLineTitle: 10,
        styleTitle:
            Theme.of(context).textTheme.title.copyWith(color: accentColor),
        styleDescription:
            Theme.of(context).textTheme.body1.copyWith(color: accentColor),
        backgroundColor: Colors.white,
        heightImage: 200,
        pathImage: "assets/slide1.png",
        title: "Benvenuto in WOM diAry!",
        description:
            "Come un filo d’Arianna, i dati conservati sul tuo smartphone "
            "offorno un supporto prezioso e attendibile alla tua memoria e "
            "abilitano nuove forme di partecipazione attiva e coesione sociale.",
      ),
      Slide(
        maxLineTitle: 10,
        styleTitle:
            Theme.of(context).textTheme.title.copyWith(color: accentColor),
        styleDescription:
            Theme.of(context).textTheme.body1.copyWith(color: accentColor),
        backgroundColor: Colors.white,
        heightImage: 200,
        pathImage: "assets/slide2.png",
        title: "Tieni traccia dei tuoi spostamenti, rigorosamente in locale",
        description: "WOM diAry conserva memoria locale e privata dei tuoi "
            "spostamenti per premiare la tua partecipazione ad eventi e arricchire le modalità di fruizione dei luoghi che visiti. Puoi esportare in qualsiasi momento tutti i dati raccolti.",
      ),
      Slide(
        maxLineTitle: 10,
        styleTitle:
            Theme.of(context).textTheme.title.copyWith(color: accentColor),
        styleDescription:
            Theme.of(context).textTheme.body1.copyWith(color: accentColor),
        backgroundColor: Colors.white,
        heightImage: 200,
        pathImage: "assets/slide3.png",
        title:
            'Informazioni, segnalazioni e opportunità di tuo reale interesse',
        description:
            'WOM diAry ti consente di scaricare "Call to Action": informazioni, segnalazioni e contenuti speciali riferiti a specifici luoghi ed eventi.\n'
            'WOM diAry usa la propria memoria per selezionare per te solo quelle di reale interesse, riferite ai luoghi che hai visitato e agli eventi a cui hai effettivamente partecipato.',
      ),
      descriptionSlide,
      Slide(
        maxLineTitle: 10,
        styleTitle:
            Theme.of(context).textTheme.title.copyWith(color: accentColor),
        styleDescription:
            Theme.of(context).textTheme.body1.copyWith(color: accentColor),
        backgroundColor: Colors.white,
        heightImage: 200,
        pathImage: "assets/slide5.png",
        title: Platform.isAndroid ? "Fatto! Giusto un'ultima cosa" : "È tutto!",
        description: Platform.isAndroid
            ? 'Prima di terminare il tutorial, ti verrà '
                'richiesto di disabilitare l\'ottimizzazione batteria per l\'app.\n'
                'Ti raccomandiamo caldamente di permetterlo per consentire a WOM diAry di funzionare correttamente e continuamente in background per non avere "vuoti di memoria".'
            : 'Puoi iniziare subito a guadagnare WOM attivando il servizio dalla pagina principale dell\'applicazione.',
      ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemOverlayStyle(context),
      child: FocusDetector(
        key: _focusDetectorKey,
        onFocusGained: () async {
          isPocketInstalled = await context
              .read<WomPocketNotifier>()
              .checkIfPocketIsInstalled();
          SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {});
          });
        },
        child: IntroSlider(
          styleNameDoneBtn: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontSize: 16, color: accentColor),
          styleNameSkipBtn: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontSize: 16, color: accentColor),
          styleNamePrevBtn: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontSize: 16, color: accentColor),
          onDonePress: this.onDonePress,
          slides: slides,
        ),
      ),
    );
  }
}
