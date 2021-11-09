import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'models/models.dart';
import 'auth/auth_service.dart';
import 'auth/auth_view.dart';
import 'settings/settings_view.dart';
import 'group_list/group_list_view.dart';
import 'manage_group/manage_group_view.dart';
import 'group_detail/group_detail_view.dart';
import 'card_detail/card_detail_view.dart';
//import 'manage_card/manage_card_view.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return CupertinoApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          //theme: const CupertinoThemeData(brightness: Brightness.light),
          /* darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode, */

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialWithModalsPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                /* if (!AuthService.instance.isAuthenticated) {
                  return const AuthView();
                } */
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case ManageGroupView.routeName:
                    final args = routeSettings.arguments as int;
                    return ManageGroupView(groupId: args);
                  case GroupDetailView.routeName:
                    final args = routeSettings.arguments as int;
                    return GroupDetailView(groupId: args);
                  /* case ManageCardView.routeName:
                    final args = routeSettings.arguments as ManageCardModel;
                    return ManageCardView(
                      bankCodeId: args.bankCodeId,
                      groupId: args.groupId,
                      cardId: args.cardId,
                    ); */
                  case CardDetailView.routeName:
                    final args = routeSettings.arguments as ManageCardModel;
                    return CardDetailView(
                      bankCodeId: args.bankCodeId,
                      groupId: args.groupId,
                      cardId: args.cardId,
                    );
                  case GroupListView.routeName:
                  default:
                    return const GroupListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
