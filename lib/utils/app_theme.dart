import 'package:diary/presentation/widgets/track_shape.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/*
 * Static class that implements the specifics of light and dark theme, and 
 * groups some theme-specific features such as SystemUiOverlayStyle.
 */
class AppTheme {

  static bool isNightModeOn(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }


  static SystemUiOverlayStyle systemOverlayStyle(BuildContext context) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: isNightModeOn(context)
          ? Brightness.dark
          : Brightness.light,
      statusBarIconBrightness: isNightModeOn(context)
          ? Brightness.light
          : Brightness.dark,
      systemNavigationBarColor: Theme.of(context).primaryColor,
      systemNavigationBarIconBrightness: isNightModeOn(context)
          ? Brightness.light
          : Brightness.dark,
    );
  }

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    accentColor: accentColor,
    accentColorBrightness: Brightness.dark,
    fontFamily: 'Nunito',

    appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: accentColor),
        actionsIconTheme: IconThemeData(color: accentColor),
        brightness: Brightness.light
    ),

    colorScheme: ColorScheme.light(
        secondary: baseCard,
        secondaryVariant: deactivatedCard
    ),

    cardTheme: CardTheme(
      color: baseCard,
    ),

    iconTheme: IconThemeData(
      color: accentColor,
    ),

    accentIconTheme: IconThemeData(
      color: Colors.white,
    ),

    snackBarTheme: SnackBarThemeData(
      contentTextStyle: secondaryStyleLight,
      actionTextColor: Colors.white,
    ),

    sliderTheme: SliderThemeData(
      trackShape: CustomTrackShape(),
      activeTrackColor: accentColor,
      inactiveTrackColor: baseCard,
      inactiveTickMarkColor: baseCard,
      thumbColor: accentColor,
      overlayColor: Color(0xFFC0CCDA).withOpacity(0.4),
      overlappingShapeStrokeColor: accentColor,
      valueIndicatorColor: accentColor,
    ),

    textTheme: TextTheme(
      title: appBarTitleStyle,
      headline: headlineStyle,
      subhead: primaryStyle,
      body1: secondaryStyle,
      body2: secondaryStyleDarker,
      caption: captionStyle,
      button: buttonTextStyle
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    primaryColor: Colors.black,
    accentColor: accentColor,
    accentColorBrightness: Brightness.dark,
    fontFamily: 'Nunito',

    appBarTheme: AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(color: Colors.white,),
      actionsIconTheme: IconThemeData(color: Colors.white),
      brightness: Brightness.dark
    ),

    colorScheme: ColorScheme.light(
        secondary: baseCardDark,
        secondaryVariant: deactivatedCardDark
    ),

    cardTheme: CardTheme(
      color: baseCardDark,
    ),

    iconTheme: IconThemeData(
      color: Colors.white,
    ),

    accentIconTheme: IconThemeData(
      color: Colors.white,
    ),

    dividerColor: Colors.grey,

    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black,
      contentTextStyle: secondaryStyleLight,
      actionTextColor: Colors.white
    ),

    sliderTheme: SliderThemeData(
      trackShape: CustomTrackShape(),
      activeTrackColor: Colors.white,
      inactiveTrackColor: baseCardDark,
      inactiveTickMarkColor: baseCardDark,
      thumbColor: Colors.white,
      overlayColor: Color(0xFFC0CCDA).withOpacity(0.4),
      overlappingShapeStrokeColor: accentColor,
      valueIndicatorColor: accentColor,
    ),

    textTheme: TextTheme(
      title: appBarTitleStyleLight,
      headline: headlineStyleLight,
      subhead: primaryStyleLight,
      body1: secondaryStyleLight,
      body2: secondaryStyleLight,
      caption: captionStyleLight,
      button: buttonTextStyle
    ),
  );
}
