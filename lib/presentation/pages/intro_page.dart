import 'dart:io';

import 'package:diary/presentation/pages/root/root_page.dart';
import 'package:diary/utils/app_theme.dart';
import 'package:diary/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class IntroPage extends StatefulWidget {
  final bool fromSettings;

  IntroPage({Key key, this.fromSettings = false}) : super(key: key);

  @override
  IntroPageState createState() => new IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemOverlayStyle(context),
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
        slides: [
          new Slide(
            maxLineTitle: 10,
            styleTitle:
                Theme.of(context).textTheme.title.copyWith(color: accentColor),
            styleDescription:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
            backgroundColor: Colors.white,
            heightImage: 200,
            pathImage: "assets/slide1.png",
            title: "Benvenuto in diAry!",
            description:
                "Come un filo d’Arianna, i dati conservati sul tuo smartphone "
                "offorno un supporto prezioso e attendibile alla tua memoria.",
          ),
          new Slide(
            maxLineTitle: 10,
            styleTitle:
                Theme.of(context).textTheme.title.copyWith(color: accentColor),
            styleDescription:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
            backgroundColor: Colors.white,
            heightImage: 200,
            pathImage: "assets/slide2.png",
            title:
                "Tieni traccia dei tuoi spostamenti, rigorosamente in locale",
            description: "Conserva una memoria locale e privata dei tuoi "
                "spostamenti, segnalando eventuali eventi di interesse. DiAry "
                "ti dà inoltre la possibilità di esportare tutti i dati raccolti, "
                "in qualsiasi momento.",
          ),
          new Slide(
            maxLineTitle: 10,
            styleTitle:
                Theme.of(context).textTheme.title.copyWith(color: accentColor),
            styleDescription:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
            backgroundColor: Colors.white,
            heightImage: 200,
            pathImage: "assets/slide3.png",
            title: "Informazioni e segnalazioni di tuo reale interesse",
            description:
                "Autorità sanitarie e soggetti autorizzati possono emanare "
                "segnalazioni, riferite a specifici luoghi e orari.\n"
                "diAry ti mostra solo quelle di reale interesse, incrociandole con le tue tracce in locale.",
          ),
          new Slide(
            maxLineTitle: 10,
            styleTitle:
                Theme.of(context).textTheme.title.copyWith(color: accentColor),
            styleDescription:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
            backgroundColor: Colors.white,
            heightImage: 200,
            pathImage: "assets/slide4.png",
            title: "Voucher per impegno sociale",
            description: "Utilizzare l’app è una scelta individuale che genera "
                "valore sociale. Tale valore è quantificato in termini di WOM, "
                "voucher concepiti nell’ambito di un progetto europeo e inclusi "
                "tra gli strumenti di innovazione sociale digitale della "
                "Commissione Europea.",
          ),
          new Slide(
            maxLineTitle: 10,
            styleTitle:
                Theme.of(context).textTheme.title.copyWith(color: accentColor),
            styleDescription:
                Theme.of(context).textTheme.body1.copyWith(color: accentColor),
            backgroundColor: Colors.white,
            heightImage: 200,
            pathImage: "assets/slide5.png",
            title: Platform.isAndroid
                ? "Fatto! Giusto un'ultima cosa"
                : "È tutto!",
            description: Platform.isAndroid
                ? "Prima di terminare il tutorial, ti verrà "
                    "richiesto di disabilitare l'ottimizzazione batteria per l'app.\n"
                    "Ti raccomandiamo caldamente di permetterlo per consentire a diAry di funzionare correttamente e continuamente in background."
                : "Ricorda: l’app non rappresenta un’alternativa alle norme di prevenzione "
                    "vigenti, seppur ci auguriamo ne diverrà un importante alleato. "
                    "Segui sempre le indicazioni del Ministero della Salute.",
          ),
        ],
      ),
    );
  }
}
