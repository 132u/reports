import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/avance.dart';
import '../screens/new_report.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      actions: [
        PopupMenuButton(
            onSelected: (value) {
              if (value == 'Отчет') {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const NewReportScreen()));
              } else {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => NewAvanceScreen()));
              }
            },
            itemBuilder: (context) => const [
                  PopupMenuItem(
                    child: Text('Отчет'),
                    value: 'Отчет',
                  ),
                  PopupMenuItem(child: Text('Аванс/Сдал'), value: 'Аванс/сдал'),
                ]),
        IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.green,
            )),
      ],
    );
  }

  final Color backgroundColor = Colors.red;
  final Text title;
  final AppBar appBar;

  /// you can add more fields that meet your needs

  const BaseAppBar({super.key, required this.title, required this.appBar});
}
