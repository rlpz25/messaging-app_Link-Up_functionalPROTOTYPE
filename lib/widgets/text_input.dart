import 'package:flutter/material.dart';

  Color _colorTextoPrincipal = Color(0xff121215);
  Color _colorTextoDeshabilitado = Color(0x8c121215);

InputDecoration campoDatos(String labelText, Icon preffixIcon, bool passType, GestureDetector suffixIcon,){
  return InputDecoration(
    prefixIcon: preffixIcon,
    labelText: labelText,
    labelStyle: TextStyle(
      color: _colorTextoDeshabilitado,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: _colorTextoPrincipal,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: _colorTextoDeshabilitado,
      ),
    ),
    suffixIcon: passType == true ? suffixIcon: null,
  );
}

InputDecoration campoDeTexto(String labelText, Icon preffixIcon){
  return InputDecoration(
    prefixIcon: preffixIcon,
    labelText: labelText,
    labelStyle: TextStyle(
      color: _colorTextoDeshabilitado,
    ),
    border: InputBorder.none,
  );
}