import 'package:flutter/material.dart';

import 'colors.dart';

// used in app bar title and calendar button
const appBarTitleStyle = TextStyle(
    fontSize: 20, color: accentColor, fontWeight: FontWeight.bold, fontFamily: "Nunito");
const appBarTitleStyleLight = TextStyle(
    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Nunito");



// used for card title and other generic title, like titles in botton sheets
const headlineStyle = TextStyle(fontSize: 25, color: accentColor, fontFamily: "Nunito");
const headlineStyleLight = TextStyle(fontSize: 25, color: Colors.white, fontFamily: "Nunito");

// used in lists, for the title of each row
const primaryStyle = TextStyle(
    fontSize: 15, color: accentColor, fontWeight: FontWeight.bold, fontFamily: "Nunito");
const primaryStyleLight = TextStyle(
    fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold, fontFamily: "Nunito");

// used for body and cards generic text, and for subtitle in lists
const secondaryStyle = TextStyle(
    fontSize: 15, color: secondaryText, fontWeight: FontWeight.normal, fontFamily: "Nunito");
const secondaryStyleLight = TextStyle(
    fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: "Nunito");

// body generic text with a darker color
const secondaryStyleDarker =
TextStyle(fontSize: 17, color: accentColor, fontWeight: FontWeight.normal, fontFamily: "Nunito");

// used for small caption text such as the character counter of the TextField
const captionStyle = TextStyle(
    fontSize: 12, color: secondaryText, fontWeight: FontWeight.normal, fontFamily: "Nunito");
const captionStyleLight = TextStyle(
    fontSize: 12, color: Colors.white, fontWeight: FontWeight.normal, fontFamily: "Nunito");

// used in genericButtons to display a text
const buttonTextStyle =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600);

// todo edit
const whiteText = TextStyle(color: Colors.white);
