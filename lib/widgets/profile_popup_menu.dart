import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmail_app/helpers/custom_route.dart';
import 'package:webmail_app/providers/auth.dart';

import 'package:webmail_app/utils/gallery_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePopupMenu {
  static BuildContext profile_context;

  static PopupMenuButton<String> createPopup(context) {
    profile_context = context;
    return PopupMenuButton<String>(
      onSelected: choiceAction,
      icon: CircleAvatar(child: Icon(Icons.account_circle)),
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<String>>();
        list.add(PopupMenuItem<String>(
          child: Text(GalleryLocalizations.of(context).rallySettingsSignOut),
          value: 'logout',
        ));
        /*list.add(PopupMenuItem(
        child: Text(GalleryLocalizations.of(context).rallySettingsProfile),
        value: 'profile',
      ));*/
        return list;
      },
    );
  }

  static void choiceAction(String choice) async {
    if (choice == 'logout') {
      Provider.of<Auth>(profile_context, listen: false).logout();
    }
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', null);
    await UserController.removeFCM(FCM.getToken());
    FCM.setFcmToken(null);
    Navigator.pushNamedAndRemoveUntil(
        mycontext, Router.homeRoute, (_) => false);*/
  }
}