import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);
Color _colorSecundario = Color(0xffffd5c8);

List<dynamic> colores = {
  Colors.red,
  Colors.deepPurple,
  Colors.black,
  Colors.blue,
  Colors.deepOrangeAccent,
  Colors.yellow,
  Colors.green,
  Colors.grey,
  Colors.pinkAccent,
  Colors.indigo,
  Colors.lightBlue,
  Colors.lightGreenAccent,
  Colors.amber,
  Colors.brown,
  Colors.purpleAccent,
  Colors.amberAccent,
  Colors.redAccent,
  Colors.teal,
  Colors.tealAccent,
  Colors.cyan,
  Colors.cyanAccent,
  Colors.purple,
  Colors.deepOrange,
  Colors.yellowAccent,
} as List<Color>;

Container tarjetaBandeja (String nombre, String distintivo, String correo, bool isRead){
  return Container(
    height: 80,
    child: Row(
      children: [
        Container(
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/usuarios/user.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: Column(
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                child: Text(
                  distintivo == Constants.miDistintivo ? '(Tú) '+nombre : nombre,
                  style: TextStyle(
                    fontSize: 16,
                    color: _colorTextoPrincipal,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: double.infinity,
                child: Text(
                  'Toca aquí para ver los mensajes',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: _colorTextoDeshabilitado),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Column(
          children: [
            Spacer(),
            isRead ? Container() : Container(child: Image.asset("assets/images/link-up-media/logo.png", height: 27, color: _colorPrincipal,)),
            Spacer(),
          ],
        )
      ],
    ),
  );
}

Container tarjetaContacto (String nombre, String distintivo){
  return Container(
    width: double.infinity,
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/usuarios/user.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child:Column(
            children: [
              Spacer(),
              Container(
                width: 270,
                child: Text(
                  distintivo == Constants.miDistintivo ? '(Tú) '+nombre : nombre,
                  style: TextStyle(
                    fontSize: 16,
                    color: _colorTextoPrincipal,
                  ),
                ),
              ),
              SizedBox(height:5,),
              Container(
                width: 270,
                child: Text(
                  '@'+distintivo,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: _colorTextoDeshabilitado
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    ),
  );
}

Container tarjetaBusquedaUsuario (String nombre, String distintivo, String correo){
  return Container(
    constraints: BoxConstraints(
      maxWidth: 500
    ),
    width: double.infinity,
    height: 80,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/usuarios/user.jpg'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child:Column(
            children: [
              Spacer(),
              Container(
                constraints: BoxConstraints(
                    maxWidth: 500
                ),
                width: 270,
                child: Text(
                  distintivo == Constants.miDistintivo ? '(Tú) '+nombre : nombre,
                  style: TextStyle(
                    fontSize: 16,
                    color: _colorTextoPrincipal,
                  ),
                ),
              ),
              SizedBox(height:5,),
              Container(
                constraints: BoxConstraints(
                    maxWidth: 500
                ),
                width: 270,
                child: Text(
                  '@'+distintivo,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: _colorTextoDeshabilitado
                  ),
                ),
              ),
              SizedBox(height:5,),
              Container(
                constraints: BoxConstraints(
                    maxWidth: 500
                ),
                width: 270,
                child: Text(
                  correo,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: _colorTextoDeshabilitado
                  ),
                ),
              ),

              Spacer(),
            ],
          ),
        )
      ],
    ),
  );
}

Row burbujaMensajeSistema(String mensaje){
  return Row(
    children: [
      Spacer(),
        Container(
          constraints: BoxConstraints(
              maxWidth: 300
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: _colorTextoPrincipal,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            mensaje,
            style: TextStyle(
            fontSize: 14,
            color: _colorFondo,
          ),
        ),
      ),
      Spacer(),
    ],
  );
}

Row burbujaMensajeUsuarioActual (String mensaje){
  return Row(
    children: [
      Spacer(),
      Container(
        constraints: BoxConstraints(
          maxWidth: 300
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _colorPrincipal,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
            bottomRight: Radius.circular(3),
            bottomLeft: Radius.circular(15)
          ),
        ),
        child: Text(
          mensaje,
          style: TextStyle(
            fontSize: 15,
            color: _colorFondo,
          ),
        ),
      ),
    ],
  );
}

Row burbujaMensajeUsuarioExterno (String mensaje){
  return Row(
    children: [
      Container(
        constraints: BoxConstraints(
            maxWidth: 300
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _colorSecundario,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(3)
          ),
        ),
        child: Text(
          mensaje,
          style: TextStyle(
            fontSize: 15,
            color: _colorTextoPrincipal,
          ),
        ),
      ),
      Spacer(),
    ],
  );
}

Row burbujaMensajeGrupo (String mensaje, String remitente) {
  return Row(
    children: [
      Container(
        constraints: BoxConstraints(
            maxWidth: 300
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _colorSecundario,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(3)
          ),
        ),
        child: Text(
          remitente+': '+mensaje,
          style: TextStyle(
            fontSize: 15,
            color: _colorTextoPrincipal,
          ),
        ),
      ),
      Spacer(),
    ],
  );
}