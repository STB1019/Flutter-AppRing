import 'package:flutter/material.dart';

Widget formCheckbox() {
  var variabile;
  return FormField(builder: (FormFieldState formFieldState) {
    return Checkbox(value: null, onChanged: null);
  },
    autovalidateMode: AutovalidateMode.always,
    enabled: true,
    validator: (value){
    if(value.runtimeType == bool)
      return null;
    return "Hey, che cosa fai con la mia checkbox?";
    },
    onSaved: (newValue) => variabile=newValue,
  );
}