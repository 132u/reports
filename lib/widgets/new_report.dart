import 'package:chat_app/database_service.dart';
import 'package:chat_app/models/payment_type.dart';
import 'package:chat_app/models/report.dart';
import 'package:chat_app/widgets/reports_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
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
  var _enteredHourPrice;
  var _enteredStartAdrees;
  var _enteredEndAdrees;
  var _enteredHoursQuantity;
  String? _selectedPaymentType;
  bool _isMoneyWithme = false;
  bool _isOnPlaceWork = false;
  bool _isHourWork = false;
  bool _isCash = false;
  bool _isWithVAT = false;
  bool _isWithoutVAT = false;
  TextEditingController _startDateController = TextEditingController();
  DatabaseService service = DatabaseService();
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
    var now = DateTime.now();
    var reportData = Report(
        user.uid,
        _enteredName,
        _enteredPrice,
        now,
        _enteredStartDate,
        _enteredCustomerName,
        _isMoneyWithme,
        _selectedPaymentType,
        _enteredStartAdrees,
        _enteredEndAdrees,
        _isOnPlaceWork,
        _isHourWork,
        _enteredHourPrice,
        _enteredHoursQuantity);
    service.addReport(reportData);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const ReportsList()));
  }

  List<String> howHasMoney = ["у меня", "у Виктора"];
  Widget _showWhoHasMoney() {
    if (_selectedPaymentType == PaymentType.cash.toString().split('.')[1]) {
      return Expanded(
          child: DropdownButtonFormField(
              items: howHasMoney
                  .map((e) => DropdownMenuItem(
                        child: Text(e),
                        value: e,
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == howHasMoney[0]) {
                  setState(() {
                    _isMoneyWithme = true;
                  });
                }
              }));
    }
    return SizedBox();
  }

  Widget _showHoursPrices() {
    if (_isHourWork) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              onSaved: (value) {
                _enteredHoursQuantity = value;
              },
              maxLength: 2,
              decoration: const InputDecoration(
                label: Text('Сколько часов?'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Заполните пожалуйста колчисевто часов :)';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              onSaved: (value) {
                _enteredHourPrice = value;
              },
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Цена за час'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Заполните пожалуйста цену за час :)';
                }
                return null;
              },
            ),
          ),
        ],
      );
    }
    return Row(children: [
      Expanded(
        child: TextFormField(
          onSaved: (value) {
            _enteredPrice = value;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            label: Text('Цена'),
          ),
          validator: (value) {
            if (value == null ||
                value.trim().isEmpty ||
                int.tryParse(value) == null) {
              return 'Заполните пожалуйста поле Цена :)';
            }
            return null;
          },
        ),
      ),
    ]);
  }

  Widget _showPaymentTypeAndWhoHasMoney() {
   return  Expanded(
                      child: DropdownButtonFormField(
                          items: PaymentType.values
                              .map((e) => DropdownMenuItem(
                                    child: Text(e.toString().split('.')[1]),
                                    value: e.toString().split('.')[1],
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentType = value;
                            });
                          }),
                    );
  }

  Widget _showAddresses() {
    if (!_isOnPlaceWork) {
      return Row(
        //адреса
        children: [
          Expanded(
            child: TextFormField(
              onSaved: (value) {
                _enteredStartAdrees = value;
              },
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Адрес погрузки'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Заполните пожалуйста адрес погрузки :)';
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: TextFormField(
              onSaved: (value) {
                _enteredEndAdrees = value;
              },
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Адрес выгрузки'),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Заполните пожалуйста адрес выгрузки :)';
                }
                return null;
              },
            ),
          ),
        ],
      );
    }
    return Row(
      //адреса
      children: [
        Expanded(
          child: TextFormField(
            onSaved: (value) {
              _enteredStartAdrees = value;
            },
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Адрес'),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Заполните пожалуйста адрес :)';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить новый отчет'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            Column(
              children: [
                TextFormField(
                  onSaved: (value) {
                    _enteredName = value;
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Коротко о заказе'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Заполните пожалуйста поле Коротко о заказе :)';
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
                    label: Text('Имя заказчика'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Заполните пожалуйста имя заказчика :)';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _startDateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate:
                            DateTime.now().add(const Duration(days: -120)),
                        lastDate:
                            DateTime.now().add(const Duration(days: 120)));
                    _startDateController.text =
                        "${pickedDate!.day}-${pickedDate.month}-${pickedDate.year}"; //pickedDate!.toString();// DateFormat.yMMMd().format(pickedDate!);
                  },
                  onSaved: (value) {
                    _enteredStartDate = DateFormat("dd-M-yyyy").parse(value!);
                  },
                  maxLength: 50,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded),
                    label: Text('Дата выполнения заказа'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Заполните пожалуйста поле Дата выполнения заказа';
                    }
                    return null;
                  },
                ),
                CheckboxListTile(
                  title: Text("Работа на месте?"),
                  value: _isOnPlaceWork,
                  onChanged: (value) {
                    setState(() {
                      _isOnPlaceWork = value!;
                    });
                  },
                  // controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                _showAddresses(),
                CheckboxListTile(
                  title: Text("Почасовка?"),
                  value: _isHourWork,
                  onChanged: (value) {
                    setState(() {
                      _isHourWork = value!;
                    });
                  },
                  // controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                _showHoursPrices(),
                Row(
                  children: [
                    // Expanded(
                    //   child: TextFormField(
                    //     onSaved: (value) {
                    //       _enteredPrice = value;
                    //     },
                    //     keyboardType: TextInputType.number,
                    //     decoration: const InputDecoration(
                    //       label: Text('Цена'),
                    //     ),
                    //     validator: (value) {
                    //       if (value == null ||
                    //           value.trim().isEmpty ||
                    //           int.tryParse(value) == null) {
                    //         return 'Заполните пожалуйста поле Цена :)';
                    //       }
                    //       return null;
                    //     },
                    //   ),
                    // ),
                    const SizedBox(
                      width: 8,
                    ),
                    _showPaymentTypeAndWhoHasMoney(),
                    Container(child: _showWhoHasMoney())
                    // Expanded(
                    //   child: DropdownButtonFormField(
                    //       items: PaymentType.values
                    //           .map((e) => DropdownMenuItem(
                    //                 child: Text(e.toString().split('.')[1]),
                    //                 value: e.toString().split('.')[1],
                    //               ))
                    //           .toList(),
                    //       onChanged: (value) {
                    //         setState(() {
                    //           _selectedPaymentType = value;
                    //         });
                    //       }),
                    // ),
                    //Container(child: _showWhoHasMoney())
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          _formKey.currentState!.reset();
                        },
                        child: const Text('Очистить форму')),
                    ElevatedButton(
                        onPressed: _addReport,
                        child: const Text('Добавить отчет')),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
