import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorSecundario = Color(0xffffd5c8);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class PantallaEspera extends StatefulWidget {
  @override
  _PantallaEsperaState createState() => _PantallaEsperaState();
}

class _PantallaEsperaState extends State<PantallaEspera> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        color: _colorFondo,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'Link-Up',
                style: TextStyle(
                  fontSize: 70,
                  color: _colorTextoPrincipal,
                ),
              ),
              SizedBox(height: 20,),
              Image.asset(
                'assets/images/link-up-media/logo.png',
                width: 300,
                color: _colorTextoPrincipal,
              ),
              Spacer(),
              Container(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: [
                    Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_colorPrincipal),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      child: Text(
                        'Cargando...',
                        style: TextStyle(color: _colorPrincipal),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
