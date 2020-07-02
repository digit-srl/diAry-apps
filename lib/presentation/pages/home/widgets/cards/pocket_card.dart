import 'package:diary/application/gps_notifier.dart';
import 'package:diary/application/wom_pocket_notifier.dart';
import 'package:diary/presentation/widgets/generic_button.dart';
import 'package:diary/utils/colors.dart';
import 'package:diary/utils/custom_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import 'home_generic_card.dart';

class PocketCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StateNotifierBuilder<bool>(
      stateNotifier: context.watch<WomPocketNotifier>(),
      builder: (BuildContext context, installed, Widget child) {
        if (!installed) {
          return HomeGenericCard(
            enabled: installed,
            iconData: CustomIcons.pocket_logo,
            iconColor: accentColor,
            title: 'WOM Pocket non installato',
            description:
                'Installa l\'applicazione WOM pocket che ti consente di collezionare e utilizzare voucher di impegno sociale',
            bottomButtons: [
              GenericButton(
                onPressed: () {
                  StoreRedirect.redirect(
                      androidAppId: 'social.wom.pocket',
                      iOSAppId: "1466969163");
                },
                text: 'Installa',
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
