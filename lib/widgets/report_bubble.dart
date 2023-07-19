import 'package:chat_app/screens/reports.dart';
import 'package:chat_app/screens/report.dart';
import 'package:chat_app/widgets/reports_list.dart';
import 'package:flutter/material.dart';

class ReportItem extends StatelessWidget {
  const ReportItem(this.name, this.customerName, this.price);

  //final DateTime startDate;
  final String name;
  final String customerName;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ReportScreen(name)));},
          child: Row(
            children: [
              Text(name),
              const SizedBox(
                width: 10,
              ),
              Text(customerName),
              const SizedBox(
                width: 10,
              ),
              Text(price.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
