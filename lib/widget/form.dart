import 'package:flutter/material.dart';

Widget formCheckbox(value,Function onChanged,{Function onSaved}) {
  return FormField(builder: (FormFieldState formFieldState) {
    return Checkbox(value: value, onChanged: onChanged);
  },
    autovalidateMode: AutovalidateMode.always,
    enabled: true,
    validator: (value){
    if(value.runtimeType == bool)
      return null;
    return "Hey, che cosa fai con la mia checkbox?";
    },
    onSaved: onSaved
  );
}

Widget formCheckboxLitTile(value,onChanged){
  return FormField(
    enabled: true,
    builder: (FormFieldState state) {
      return CheckboxListTile(
        value: value,
        title: Text("Visibilità"),
        onChanged: onChanged
      );
    },
  );
}