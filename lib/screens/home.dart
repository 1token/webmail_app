import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:webmail_app/utils/gallery_localizations.dart';
import 'package:webmail_app/utils/adaptive.dart';
import 'package:webmail_app/widgets/home_app_bar.dart';

const drawerDesktopWidth = 200.0;

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    this.firstFocusNode,
    this.lastFocusNode,
  }) : super(key: key);

  final FocusNode firstFocusNode;
  final FocusNode lastFocusNode;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = isDisplayDesktop(context);
    final body = SafeArea(
      child: Padding(
        padding: isDesktop
            ? EdgeInsets.symmetric(horizontal: 72, vertical: 48)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GalleryLocalizations.of(context).starterAppGenericHeadline,
              style: textTheme.display2.copyWith(
                color: colorScheme.onSecondary,
              ),
            ),
            SizedBox(height: 10),
            Text(
              GalleryLocalizations.of(context).starterAppGenericSubtitle,
              style: textTheme.subhead,
            ),
            SizedBox(height: 48),
            Text(
              GalleryLocalizations.of(context).starterAppGenericBody,
              style: textTheme.body2,
            ),
          ],
        ),
      ),
    );

    if (isDesktop) {
      return Row(
        children: [
          ListDrawer(
            isDesktop: isDesktop,
            lastFocusNode: lastFocusNode,
          ),
          VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: HomeAppBar(
                firstFocusNode: firstFocusNode,
                isDesktop: true,
              ),
              body: body,
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {},
                label: Text(
                  GalleryLocalizations.of(context).starterAppGenericButton,
                  style: TextStyle(color: colorScheme.onSecondary),
                ),
                icon: Icon(Icons.add, color: colorScheme.onSecondary),
                tooltip: GalleryLocalizations.of(context).starterAppTooltipAdd,
              ),
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: HomeAppBar(
          firstFocusNode: firstFocusNode,
          isDesktop: true,
        ),
        body: body,
        drawer: ListDrawer(),
        // drawerEdgeDragWidth: MediaQuery.of(context).size.width - 250,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: GalleryLocalizations.of(context).starterAppTooltipAdd,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          focusNode: lastFocusNode,
        ),
      );
    }
  }
}

class ListDrawer extends StatefulWidget {
  const ListDrawer({Key key, this.isDesktop = false, this.lastFocusNode})
      : super(key: key);

  final bool isDesktop;
  final FocusNode lastFocusNode;

  @override
  _ListDrawerState createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  static final numItems = 19;

  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: widget.isDesktop ? drawerDesktopWidth : null,
      child: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  GalleryLocalizations.of(context).starterAppTitle,
                  style: textTheme.title,
                ),
                subtitle: Text(
                  GalleryLocalizations.of(context).starterAppGenericSubtitle,
                  style: textTheme.body1,
                ),
              ),
              Divider(),
              ...Iterable<int>.generate(numItems).toList().map((i) {
                final listTile = ListTile(
                  enabled: true,
                  selected: i == selectedItem,
                  leading: Icon(Icons.favorite),
                  title: Text(
                    GalleryLocalizations.of(context)
                        .starterAppDrawerItem(i + 1),
                  ),
                  onTap: () {
                    setState(() {
                      selectedItem = i;
                    });
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                      // Navigator.of(context).pop();
                      // Navigator.popAndPushNamed(context, "/new_page");
                      // Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => Page2()));
                    }
                  },
                );

                if (i == numItems - 1 && widget.lastFocusNode != null) {
                  return Focus(
                    focusNode: widget.lastFocusNode,
                    child: listTile,
                  );
                } else {
                  return listTile;
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
