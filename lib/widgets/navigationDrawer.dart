import 'package:chat_app/screens/reports.dart';
import 'package:flutter/material.dart';

import '../screens/AvancesScreen.dart';

class MyNavigationDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:<Widget> [
            buildHeader(context),
            buildMenuItems(context),
        ],
      )),
    );    
  }
  
  buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top:MediaQuery.of(context).padding.top,
      ),
      child: const Text('Отчеты'),
    );
  }

  buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text('Мои отчеты'),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context)
              .push(MaterialPageRoute(builder: (context)=>ReportsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text('Мои авансы/сдачи'),
            onTap: (){
              Navigator.pop(context);
              Navigator.of(context)
              .push(MaterialPageRoute(builder: (context)=>AvancesScreen()));
            },
          )
        ],
      ),
    );
  }
}

