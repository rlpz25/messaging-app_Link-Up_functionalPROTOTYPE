import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'Contactos.dart';
import 'Bandeja.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  @override
  Widget build(BuildContext context) {

    FlutterStatusbarcolor.setStatusBarColor(_colorPrincipal);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(_colorFondo);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90,
          elevation: 0,
          leading: Row(
            children: [
              SizedBox(width: 13,),
              Column(
                children: [
                  Spacer(),
                  GestureDetector(
                    child: CircleAvatar(
                      minRadius: 10,
                      maxRadius: 20,
                      backgroundImage: AssetImage("assets/images/usuarios/user.jpg"),
                    ),
                    onTap: (){
                      Navigator.pushNamed(context, '/ajustes');
                    },
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            GestureDetector(
                child: Icon(
                    Icons.search,
                color: _colorFondo,
                ),
                onTap: (){
                  Navigator.pushNamed(context, '/busqueda');
                },
            ),
            SizedBox(width: 10,),
          ],
          title: Text(
            'Link-Up',
          ),
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: _colorFondo,
            tabs: [
              Container(
                height: 35,
                child: Row(
                  children: [
                    Spacer(),
                    Center(
                      child: Icon(Icons.message),
                    ),
                    SizedBox(width: 10,),
                    Center(
                      child: Text(
                        'BANDEJA',
                        style: TextStyle(
                          fontSize: 15,
                          color: _colorFondo,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              Container(
                height: 35,
                child: Row(
                  children: [
                    Spacer(),
                    Center(
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 10,),
                    Center(
                      child: Text(
                        'CONTACTOS',
                        style: TextStyle(
                          fontSize: 15,
                          color: _colorFondo,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Bandeja(),
            Contactos(),
          ],
        ),
      ),
    );
  }
}