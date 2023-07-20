import 'package:chat_app/models/report.dart';

class Driver{
  const Driver(this.lastName, this.firstName, this.middleName, this.reports);
  final String lastName;
  final String firstName;
  final String middleName;
  final List<Report> reports;
}