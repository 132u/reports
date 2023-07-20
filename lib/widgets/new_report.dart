import 'package:chat_app/database_service.dart';
import 'package:chat_app/models/payment_type.dart';
import 'package:chat_app/models/report.dart';
import 'package:chat_app/widgets/reports_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewReport extends StatefulWidget {
  const NewReport({super.key});

  @override
  State<NewReport> createState() {
    return _NewReportState();
  }
}

class _NewReportState extends State<NewReport> {
  var _enteredName;
  var _enteredCustomerName;
  var _enteredStartDate;
  var _enteredPrice;
  var _selectedPaymentType;
  TextEditingController _startDateController = TextEditingController();
  DatabaseService service = DatabaseService();
  // var _nameController = TextEditingController();
  // var _priceController = TextEditingController();
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _priceController.dispose();
  //   super.dispose();
  // }
  final _formKey = GlobalKey<FormState>();
  void _addReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    //calculate price method in order to save it in DB
    var now = new DateTime.now();
    var reportData = new Report(user.uid, _enteredName, _enteredPrice, now,
        _enteredStartDate, _enteredCustomerName);
    service.addReport(reportData);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => ReportsList()));
  }

Widget? _showWhoHasMoney(){
 if(_selectedPaymentType == PaymentType.cash){
 return Text('HIHIHIHIHI');  
 }
 return null;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new report'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children:[ Column(
              children: [
                TextFormField(
                  onSaved: (value) {
                    _enteredName = value;
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'name is invalid or empty!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  onSaved: (value) {
                    _enteredCustomerName = value;
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Customer name'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Customer name is invalid or empty!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  onTap: () async {
                    DateTime? pickedDate =  await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().add(Duration(days: -120)),
                        lastDate: DateTime.now().add(Duration(days: 120)));
                    _startDateController.text= pickedDate.toString();// DateFormat.yMMMd().format(pickedDate!);
          
                  },
                  onSaved: (value) {
                    _enteredStartDate = DateTime.parse(value!);                  
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded),
                    label: Text('Report Date'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Report date is invalid or empty!';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) {
                          _enteredPrice = value;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('Price'),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              int.tryParse(value) == null) {
                            return 'Price is invalid or empty!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          items: PaymentType.values
                            .map((e) => DropdownMenuItem(
                                  child: Text(e.toString().split('.')[1]),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (value)
                        {
                          setState(() {
                            _selectedPaymentType = value;
                          });
                        }),
                     //(){_showWhoHasMoney()},
                    ),
                    Container(
                          child: _showWhoHasMoney()
                        )      
                  ],
                ),
                Row(
                  children: [
                    TextButton(onPressed: () {
                      _formKey.currentState!.reset();
                    }, child: const Text('Reset')),
                    ElevatedButton(
                        onPressed: _addReport, child: const Text('Add Report')),
                  ],
                ) 
              ],
            ),]
          ),
        ),
      ),
    );
  }
}
