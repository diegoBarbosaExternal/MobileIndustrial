import 'package:flutter/material.dart';

class DropDownFormField {

  static Widget dropDownSugar({String hint, @required dropDown}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: DropdownButtonHideUnderline(
          child: dropDown
      ),
    );
  }

  static InputDecoration decoratorDropDown(){
    return InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide:
          BorderSide(color: Color.fromARGB(255, 243, 112, 33))),
    );
  }
}






