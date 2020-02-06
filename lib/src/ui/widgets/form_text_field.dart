import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyWidget {
  Widget textFormField(
    TextEditingController _controller,
    String _labelText,
    String _messageValidation,
    bool _obscureText, {
        bool verificarValidateFuncion = false,
    Function validateFunction,
    TextInputType typeText = TextInputType.text,
    bool stsEnabled = true,
    bool verificarValidate = false,
    bool autoValidate = false,
    bool campoObrigatorio = false,
    int maxLength,
    int maxLines = 1,
        Function onSaved,
        Stream stream,
        Function onChanged,
        String initialValue,
        isInputFormatters = false,
        enableInteractiveSelection = false,
        Function onTap,
        FocusNode disableFocusNode
  }) {
    return StreamBuilder<dynamic>(
      stream: stream,
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextFormField(
            textInputAction: TextInputAction.done,
            initialValue: initialValue,
            autovalidate: autoValidate,
            enabled: stsEnabled,
            obscureText: _obscureText,
            keyboardType: typeText,
            maxLength: maxLength,
            maxLines: maxLines,
            enableInteractiveSelection: enableInteractiveSelection,
            focusNode: disableFocusNode,
            onTap: onTap,
            inputFormatters: isInputFormatters ? <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ] : null,
            onSaved: onSaved,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: campoObrigatorio == false ? null
                  : Icon(Icons.ac_unit,size: 8, color: Colors.red,),
              errorText: snapshot.hasError ? snapshot.error : null,
              labelText: _labelText,
              labelStyle: TextStyle(
                  color: Color.fromARGB(255, 080, 079, 081), fontSize: 14),
              enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 243, 112, 33))),
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 243, 112, 33))),
            ),
            cursorColor: Color.fromARGB(255, 243, 112, 33),
            controller: _controller,
            validator: (value) {
              if (verificarValidate) {
                if (verificarValidateFuncion) {
                  if (validateFunction
                      .toString()
                      .isNotEmpty)
                    return validateFunction(value);
                } else {
                  if (value.isNotEmpty && value == "0.000") {
                    return _messageValidation;
                  }
                  if (value.isEmpty) {
                    return _messageValidation;
                  }
                }
                return null;
              } else
                return null;
            },
          ),
        );
      },
    );
  }
}


