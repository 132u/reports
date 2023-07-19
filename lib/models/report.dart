import 'package:chat_app/models/customer.dart';
import 'package:chat_app/models/payment_type.dart';
import 'package:flutter/material.dart';

class Report{
 // const Report(this.id, this.name, this.startAddress, this.endAddress, this.onPlace, this.price, this.paymentType, this.customer, this.startDateTime, this.endDateTime, this.isByHours, this.moneyWithMe, this.driverId, this.createdAt, this.comment);
const Report(this.driverId, this.name, this.price);
  //final String id;
  final String driverId;
  final String name;
  // final DateTime createdAt;
  // final DateTime startDateTime;
  // final DateTime endDateTime;
  // final String? startAddress;
  // final String? endAddress;
  // final bool onPlace;//работа на месте?
  // final bool isByHours;//почасовка?
  // final bool moneyWithMe;//деньги у меня?
  final String price;
  // final PaymentType paymentType;
  // final Customer customer;
  // final String comment;
  Map<String, dynamic> toMap() {
    return {
      'driverId':driverId,
      'name': name,
      'price': price,
    };
  }

  Report.fromMap(Map<String, dynamic> reportMap)
      : name = reportMap["streetName"],
        driverId = reportMap["driverId"],
        price = reportMap["price"];
}