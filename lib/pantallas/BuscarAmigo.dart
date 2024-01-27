import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/modals/UserA.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'ChatPrivado.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorSecundario = Color(0xffffd5c8);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);
Color _colorTextoDeshabilitado2 = Color(0x22121215);

class BuscarAmigo extends StatefulWidget {
  @override
  _BuscarAmigoState createState() => _BuscarAmigoState();
}

class _BuscarAmigoState extends State<BuscarAmigo> {

  final UserA usuario;
  _BuscarAmigoState({this.usuario});

  TextEditingController _busquedaTEC = new TextEditingController();

  @override
  void dispose(){
    _busquedaTEC.dispose();
    super.dispose();
  }

  QuerySnapshot searchSnapshot, contactosSnapshot;

  DatabaseMethods _databaseMethods = new DatabaseMethods();

  InitiateSearch(){
    _databaseMethods.getUserDistintivoCompletarOrdenar(_busquedaTEC.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  CreateChatPrivadoAndIniciaConversacion(String distintivo, String nombre, String correo){
    String chatId = getChatId(Constants.miDistintivo, distintivo);
    List<String> usuarios = [Constants.miDistintivo, distintivo];
    Map<String, dynamic> chatMap = {
      'usuarios' : usuarios,
      'chatId' : chatId
    };
    _databaseMethods.createChatPrivado(
      chatId,
      chatMap
    );
    _databaseMethods.getMensajes(chatId).then((val) {
      if(val.size == 0){
        sendMessageMethod('system', chatId, chatId, 'Se ha creado la sala', null);
      }
    });

    Navigator.pushReplacementNamed(
      context,
      '/chat-privado',
      arguments: ChatPrivadoArgumentos(
        nombre,
        distintivo,
        correo
      )
    );
  }

  Widget searchList(){
    if (searchSnapshot != null){
      if (searchSnapshot.size != 0){
        return ListView.builder(
          shrinkWrap: true,
          itemCount: searchSnapshot.docs.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Column(
                children: [
                  tarjetaBusquedaUsuario(
                    searchSnapshot.docs[index].get('nombre'),
                    searchSnapshot.docs[index].get("distintivo"),
                    searchSnapshot.docs[index].get("correo")
                  ),
                  Container(
                    width: 300,
                    height: 0.4,
                    decoration:
                    BoxDecoration(color: _colorTextoDeshabilitado2),
                  )
                ],
              ),
              onTap: () {
                String distintivo = searchSnapshot.docs[index].get('distintivo');
                String nombre = searchSnapshot.docs[index].get('nombre');
                String correo = searchSnapshot.docs[index].get("correo");
                List<String> usuarios = [Constants.miDistintivo , distintivo];
                _databaseMethods.getConversacion(distintivo, getChatId(distintivo, Constants.miDistintivo)).then((val){
                  if(val.size == 0){
                    Map<String, dynamic> conversacionMap = {
                      'chatId' : getChatId(Constants.miDistintivo, distintivo),
                      'usuarios' : usuarios,
                      'creador' : Constants.miDistintivo,
                      'distintivo' : distintivo,
                      'nombre' : nombre,
                      'correo' : correo
                    };
                    Map<String, dynamic> conversacionMapOtro = {
                      'chatId' : getChatId(Constants.miDistintivo, distintivo),
                      'usuarios' : usuarios,
                      'creador' : Constants.miDistintivo,
                      'distintivo' : Constants.miDistintivo,
                      'nombre' : Constants.miNombre,
                      'correo' : Constants.miCorreo
                    };
                    _databaseMethods.agregarConversacion(getChatId(Constants.miDistintivo, distintivo), Constants.miDistintivo, conversacionMap);
                    _databaseMethods.agregarConversacionOtro(getChatId(Constants.miDistintivo, distintivo), distintivo, conversacionMapOtro);
                  }
                });
                CreateChatPrivadoAndIniciaConversacion(distintivo, nombre, correo);
              },
              onDoubleTap: (){
                String distintivo = searchSnapshot.docs[index].get('distintivo');
                String nombre = searchSnapshot.docs[index].get('nombre');
                String correo = searchSnapshot.docs[index].get("correo");
                Map<String, dynamic> contactoMap = {
                  'distintivo' : distintivo,
                  'correo' : correo,
                  'nombre' : nombre
                };
                _databaseMethods.agregarContacto(Constants.miDistintivo, distintivo, contactoMap);
              },
            );
          },
        );
      } else {
        return Container(
          child: Center(
              child: Text(
                'No tenemos registros cercanos a tu búsqueda, por favor, ingresa un distintivo diferente.',
                style: TextStyle(fontSize: 20, color: _colorTextoDeshabilitado),
                textAlign: TextAlign.center,
              )
          ),
        );
      }
    } else {
      return Container(
        child: Center(
            child: Text(
              'Ingresa un distintivo',
              style: TextStyle(fontSize: 20, color: _colorTextoDeshabilitado),
            )
        ),
      );
    }
  }

  /*@override
  void initState() {
    InitiateSearch();
    super.initState();
  }*/

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
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: _colorSecundario, width: 2),
                            color: _colorFondo,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 15,),
                            Expanded(
                              child: TextField(
                                controller: _busquedaTEC,
                                autofocus: false,
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
                          Icons.person_search,
                          color: _colorFondo,
                        )
                    ),
                    onTap: (){
                      InitiateSearch();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: searchList()
            ),
          ],
        ),
      ),
    );
  }
}

String getChatId(String a, String b){
  if(a.compareTo(b) < 0)
    return '$a\_$b';
  else
    return '$b\_$a';
}

