import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return AuthScreenState();
  }
}

class AuthScreenState extends State<AuthScreen> {
  var _isAuthenticating = false;
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || !_isLogin && _selectedImage == null) {
      return;
    }
    //this will trigger onSaved function in each text form
    _formKey.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        var userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        print(userCredentials);
      } else {
        var userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        //store image in firebase
       final storageRef =  FirebaseStorage.instance.ref().child('user_images').child('${userCredentials.user!.uid}.jpg');
       await storageRef.putFile(_selectedImage!);
       final imageUrl = await storageRef.getDownloadURL();
       FirebaseFirestore.instance.collection('users').doc(userCredentials.user!.uid).set(
        {'username':_enteredUsername,
        'email' :_enteredEmail,
        'image_url':imageUrl,
        }
       );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      // if(error.code='invalid-email')
      // {

      // }
      // if(error.code='weak-password')
      // {

      // }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Auth failed')),
      );
       setState(() {
        _isAuthenticating = false;
      });
    }
  }

  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername ='';

  @override
  Widget build(BuildContext context) {
    //Scaffold allows you to put appbar and etc usefule properties
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
          //SingleChildScrollView allows you to scroll elements and all elements are reachable even keyboard is open
          child: SingleChildScrollView(
        child: Column(
            //MainAxisAlignment.center: выравнивание по вертикали по центру
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //margin: устанавливает отступы текущего виджета Container от границ внешнего контейнера, аналогично настройке параметра padding
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        if(!_isLogin)
                          UserImagePicker(onPickImage: (pickedImage){
                            _selectedImage = pickedImage;
                          }),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Email is invalid.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        if(!_isLogin)
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Username",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  value.trim().length < 4) {
                                return 'Username is invalid.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsername = value!;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password is invalid.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if(_isAuthenticating)
                          const CircularProgressIndicator(),
                        if(!_isAuthenticating)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                        if(!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin
                                ? 'Create an account'
                                : 'I already have an account'),
                          )
                      ]),
                    ),
                  ),
                ),
              )
            ]),
      )),
    );
  }
}
