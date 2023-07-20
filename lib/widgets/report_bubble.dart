import 'package:chat_app/screens/reports.dart';
import 'package:chat_app/screens/report.dart';
import 'package:chat_app/widgets/reports_list.dart';
import 'package:flutter/material.dart';

import '../models/report.dart';

class ReportItem extends StatelessWidget {
  const ReportItem(this.report);
final Report report;
  //final DateTime startDate;
  // final String name;
  // final String customerName;
  // final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ReportScreen(report.name)));},
          child: Expanded(
            child: Row(
              children: [
                Text(report.name),
                const SizedBox(
                  width: 10,
                ),
                Text(report.customer),
                const SizedBox(
                  width: 10,
                ),
                Text(report.price),
                const SizedBox(
                  width: 10,
                ),
                Text(report.isMoneyWithMe ? "Деньги у меня":"Деньги у Виктора"),
                const SizedBox(
                  width: 10,
                ),
                Text("Тип оплаты:${report.paymentType}"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
