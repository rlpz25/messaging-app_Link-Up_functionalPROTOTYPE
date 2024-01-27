import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorSecundario = Color(0xffffd5c8);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class Busqueda extends StatefulWidget {
  @override
  _BusquedaState createState() => _BusquedaState();
}

class _BusquedaState extends State<Busqueda> {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(_colorPrincipal);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(_colorFondo);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Link-Up'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: _colorSecundario, width: 2),
                      color: _colorFondo,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 15,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: _colorSecundario, width: 2),
                                    color: _colorFondo,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 15,),
                                    Expanded(
                                      child: TextField(
                                        autofocus: true,
                                        style: TextStyle(
                                          color: _colorTextoPrincipal,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Buscar...',
                                          hintStyle: TextStyle(
                                            color: _colorTextoDeshabilitado,
                                          ),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                  ],
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _colorPrincipal,
                                ),
                                child: Icon(
                                  Icons.search,
                                  color: _colorFondo,
                                )
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15,),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
