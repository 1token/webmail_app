import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmail_app/helpers/custom_route.dart';
import 'package:webmail_app/providers/auth.dart';

import 'package:webmail_app/utils/gallery_localizations.dart';
import 'package:webmail_app/widgets/data_list.dart';
import 'package:webmail_app/widgets/detail.dart';
import 'package:webmail_app/widgets/profile_popup_menu.dart';

const appBarDesktopHeight = kToolbarHeight;

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    Key key,
    this.isDesktop = false,
    this.firstFocusNode,
  }) : super(key: key);

  final bool isDesktop;
  final FocusNode firstFocusNode;

  @override
  Size get preferredSize => isDesktop
      ? const Size.fromHeight(appBarDesktopHeight)
      : const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return AppBar(
      title: isDesktop
          ? null
          : Text(GalleryLocalizations.of(context).starterAppGenericTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: GalleryLocalizations.of(context).starterAppTooltipSearch,
          onPressed: () {
            showSearch(context: context, delegate: DataSearch(listWords));
          },
        ),
        // ProfilePopup(),
        ProfilePopupMenu.createPopup(context),
      ],
    );
  }
}

Widget ProfilePopup() {
  BuildContext profile_context;

  void choiceAction(String choice) async {
    if (choice == 'logout') {
      Provider.of<Auth>(profile_context, listen: false).logout();
    }
  }

  return PopupMenuButton<String>(
    /*onSelected: (selected) {
      switch (selected) {
        case 'logout':
          Provider.of<Auth>(profile_context, listen: false).logout();
          break;
        default:
          break;
      }
    },*/
    onSelected: choiceAction,
    icon: CircleAvatar(child: Icon(Icons.account_circle)),
    itemBuilder: (context) {
      profile_context = context;
      var list = List<PopupMenuEntry<String>>();
      list.add(PopupMenuItem<String>(
        child: Text(GalleryLocalizations.of(context).rallySettingsSignOut),
        value: 'logout',
      ));
      /*list.add(PopupMenuItem(
        child: Text(GalleryLocalizations.of(context).rallySettingsSignOut),
        value: 'profile',
      ));*/
      return list;
    },
  );
}

class DataSearch extends SearchDelegate<String> {
  final List<ListWords> listWords;

  DataSearch(this.listWords);

  @override
  List<Widget> buildActions(BuildContext context) {
    //Actions for app bar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // show some result based on the selection
    final suggestionList = listWords;

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        title: Text(listWords[index].titlelist),
        subtitle: Text(listWords[index].definitionlist),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something

    final suggestionList = query.isEmpty
        ? listWords
        : listWords
            .where((p) =>
                p.titlelist.contains(RegExp(query, caseSensitive: false)))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Detail(listWordsDetail: suggestionList[index]),
            ),
          );
        },
        trailing: Icon(Icons.remove_red_eye),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].titlelist.substring(0, query.length),
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text:
                        suggestionList[index].titlelist.substring(query.length),
                    style: TextStyle(color: Colors.grey)),
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }
}
