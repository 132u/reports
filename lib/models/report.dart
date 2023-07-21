import 'package:chat_app/models/customer.dart';
import 'package:chat_app/models/payment_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Report{
   Report(
    this.driverId,
     this.name,
      this.price,
       this.createdAt,
        this.startDateTime,this.customer, this.isMoneyWithMe, this.paymentType, this.startAddress, 
        this.endAddress, this.onPlace, this.isByHours, this.hourPrice, this.hourQuantity) {
          calculatePrice();
        }

  final String driverId;
  final String name;
  final DateTime createdAt;
  final DateTime startDateTime;
  // final DateTime endDateTime;
  final String? startAddress;
  final String? endAddress;
  final bool onPlace;//работа на месте?
  final bool isByHours;//почасовка?
  final bool isMoneyWithMe;//деньги у меня?
  String? price;
  final String? hourPrice;
  final String? hourQuantity;
  final String? paymentType;
  final String customer;
  // final String comment;
  Map<String, dynamic> toMap() {
    return {
      'driverId':driverId,
      'name': name,
      'price': price,
      'createdAt': createdAt,
       'startDateTime':startDateTime,
      // 'endDateTime': endDateTime,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'onPlace': onPlace,
      'isByHours': isByHours,
       'isMoneyWithMe': isMoneyWithMe,
     'paymentType': paymentType,
      'customer': customer,
      'hourPrice':hourPrice,
      'hourQuantity':hourQuantity
    //  'comment': comment,
    };
  }
void calculatePrice()
{
  if(isByHours){
    var f=int.parse(hourPrice!);
    var f2=int.parse(hourQuantity!);
    price = (f*f2).toString();
  }
    if(paymentType == PaymentType.withoutVAT.toString().split('.')[1]){
      price=(int.parse(price!) - int.parse(price!)*0.2).toString();}
    if(paymentType == PaymentType.withVAT.toString().split('.')[1]){
      price=(int.parse(price!) - int.parse(price!)*0.1).toString();

  }
}
  Report.fromMap(Map<String, dynamic> reportMap)
      : name = reportMap["name"],
        driverId = reportMap["driverId"],
        price = reportMap["price"],
        startDateTime = reportMap["startDateTime"].toDate(),
        customer = reportMap["customer"],
        createdAt = reportMap["createdAt"].toDate(),
        paymentType= reportMap["paymentType"],
        isByHours = reportMap["isByHours"],
        startAddress = reportMap["startAddress"],
        onPlace = reportMap["onPlace"],
        endAddress = reportMap["endAddress"],
        hourPrice = reportMap["hourPrice"],
        hourQuantity = reportMap["hourQuantity"],
        isMoneyWithMe= reportMap["isMoneyWithMe"];        
}