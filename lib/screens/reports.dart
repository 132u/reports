import 'package:flutter/material.dart';

import '../widgets/reports_list.dart';

class ReportsScreen extends StatefulWidget{
  @override
  State<ReportsScreen> createState() {
    return ReportListState();
  }
}

class ReportListState extends State<ReportsScreen>{
  @override
  Widget build(BuildContext context) {
    return  const ReportsList();
  }
}