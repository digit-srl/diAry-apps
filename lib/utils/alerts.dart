import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

/*
 * Implements a standard behavior and styling for all dialogs inside the app,
 * using the ase custom style over rflutter_alert. It provides some standardized
 * dialog templates.
 */
class Alerts {
  // alerts' common custom style
  static AlertStyle customStyle(BuildContext context) {
    return AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: false,
      isOverlayTapDismiss: true,
      descStyle: Theme.of(context).textTheme.body1,
      overlayColor: Colors.black.withOpacity(0.6),
      backgroundColor: Theme.of(context).primaryColor,
      animationDuration: Duration(milliseconds: 200),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
      titleStyle: Theme.of(context).textTheme.headline,
    );
  }


  // alert with a single button. At the end of the passed action, it dismiss the
  // dialog automatically. If button text or actions are not passed, it
  // implements a standard behavior (OK as button text, dismiss as action)
  static showAlertWithSingleAction(BuildContext context, String title,
      [String description, String buttonText, Function onButtonPressed]) async {
    return await Alert(
        context: context,
        title: title,
        desc: description,
        buttons: [
          DialogButton(
              radius: BorderRadius.circular(10.0),
              child: Text(
                buttonText ?? "OK",
                style: Theme.of(context).textTheme.button,
              ),
              color: Theme.of(context).accentColor,
              onPressed: onButtonPressed == null
                  ? () {
                      Navigator.pop(context);
                    }
                  : () {
                      onButtonPressed();
                      Navigator.pop(context);
                    })
        ]).show();
  }

  // alert with a main action button, and a secondary one.
  // At the end of the passed actions, it dismiss the dialog automatically.
  // If button text for secondary action is not passed, it
  // implements a standard behavior in it (dismiss)
  static showAlertWithPosNegActions(BuildContext context, String title,
      String description, String positiveButtonText, Function onPositive,
      [String negativeButtonText, Function onNegative]) async {
    return await Alert(
        context: context,
        title: title,
        desc: description,
        style: customStyle(context),
        buttons: [
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              negativeButtonText ?? "Annulla",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Theme.of(context).textTheme.body2.color),
            ),
            color: Colors.transparent,
              onPressed: onNegative == null
                  ? () {
                Navigator.pop(context);
              }
                  : () {
                Navigator.pop(context);
                onNegative();
              }
          ),
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              positiveButtonText,
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pop(context);
              onPositive();
            },
          )
        ]).show();
  }


  // Alert with two equally important actions.
  // At the end of the passed actions, it dismiss the dialog automatically.
  // Both actions must be passed in order for the button to work
  static showAlertWithTwoActions(
      BuildContext context,
      String title,
      String description,
      String firstButtonText,
      Function onFirstButton,
      String secondButtonText,
      Function onSecondButton) async {
    return await Alert(
        context: context,
        title: title,
        desc: description,
        style: customStyle(context),
        buttons: [
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              firstButtonText,
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              onFirstButton();
              Navigator.pop(context);
            },
          ),
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              secondButtonText,
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              onSecondButton();
              Navigator.pop(context);
            },
          )
        ]).show();
  }


  // Alert with a personalized content and no buttons.
  // It has a custom style to remove the default border of the buttons, that,
  // without buttons, makes the dialog asymmetric.
  static showAlertWithContentAndNoButtons(
      BuildContext context,
      String title,
      String description,
      Widget content) async {
    return await Alert(
      context: context,
      title: title,
      desc: description,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: false,
        isOverlayTapDismiss: true,
        descStyle: Theme.of(context).textTheme.body1,
        overlayColor: Colors.black.withOpacity(0.6),
        backgroundColor: Theme.of(context).primaryColor,
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
        buttonAreaPadding: EdgeInsets.fromLTRB(0, 0, 0, 20),
        titleStyle: Theme.of(context).textTheme.headline,
      ),
      buttons: [],
      content: content,
    ).show();
  }


  // Alert a content, passed as widget, and an action button
  // At the end of the passed actions, it dismiss the dialog automatically.
  // If button text or actions are not passed, it implements a standard behavior
  // (OK as button text, dismiss as action)
  static showAlertWithContent(BuildContext context, String title,
      Widget content, String positiveButtonText, Function onPositive) async {
    await Alert(
      style: customStyle(context),
      context: context,
      title: title,
      content: content,
        buttons: [
          DialogButton(
              radius: BorderRadius.circular(10.0),
              child: Text(
                "Annulla",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: Theme.of(context).textTheme.body2.color),
              ),
              color: Colors.transparent,
              onPressed:  () {
                Navigator.pop(context);
              }
          ),
          DialogButton(
            radius: BorderRadius.circular(10.0),
            child: Text(
              positiveButtonText,
              style: Theme.of(context).textTheme.button,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () {
              onPositive();
              Navigator.pop(context);
            },
          )
        ]
    ).show();
  }
}
