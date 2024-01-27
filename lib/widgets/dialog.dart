import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

showMaterialDialog(BuildContext context ,String titulo, String contenido) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(titulo, style: TextStyle(color: _colorPrincipal),),
        content: new Text(contenido),
        actions: <Widget>[
          FlatButton(
            child: Text('¡Cierrame!', style: TextStyle(color: Colors.red),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      )
  );
}