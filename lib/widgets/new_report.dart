import 'package:chat_app/database_service.dart';
import 'package:chat_app/models/report.dart';
import 'package:chat_app/widgets/reports_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewReport extends StatefulWidget{
  const NewReport({super.key});

  @override
  State<NewReport> createState() {
    return _NewReportState();    
  }
}

class _NewReportState extends State<NewReport>{
  var _enteredName;
  var _enteredCustomerName;
  var _enteredStartDate;
  var _enteredPrice;
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
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
    }
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    // FirebaseFirestore.instance.collection('reports').add({
    //   'name':_enteredName,
    //   'price':_enteredPrice,
    //   'driverId':user.uid,
    // });
    var now = new DateTime.now();
    var reportData = new Report(user.uid, _enteredName, _enteredPrice,now ,_enteredStartDate,_enteredCustomerName);
    service.addReport(reportData);
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>ReportsList()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new report'),
      ),
      body: 
        Padding(
          padding: EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  onSaved: (value){_enteredName = value;},
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Name'),
                    ),
                  validator: (value){
                     if(value == null || value.trim().isEmpty )
                        {
                          return 'name is invalid or empty!';
                        }
                        return null;
                    },
                ),
                 TextFormField(
                  onSaved: (value){_enteredCustomerName = value;},
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Customer name'),
                    ),
                  validator: (value){
                     if(value == null || value.trim().isEmpty )
                        {
                          return 'Customer name is invalid or empty!';
                        }
                        return null;
                    },
                ),
                InputDatePickerFormField(
                  onDateSaved: (value) {_enteredStartDate = value; },
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 120)),
                ), 

                Row(children: [
                  Expanded(
                    child: TextFormField(
                      onSaved: (value){_enteredPrice = value;},
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                      label: Text('Price'),
                      ),
                      validator:(value)
                      { 
                        if(value == null || value.trim().isEmpty || int.tryParse(value)! <= 0)
                        {
                          return 'Price is invalid or empty!';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: DropdownButtonFormField(items: [],
                     onChanged: (value){}),
                  )
                ],),
                Row(children: [
                  TextButton(onPressed: (){}, child: const Text('Reset')),
                  ElevatedButton(onPressed: _addReport, child: const Text('Add Report')),
                ],)
              ],
            ),
          ),),
    ); 
    
  }
}