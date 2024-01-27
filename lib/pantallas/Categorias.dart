import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'MensajesClasificados.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  String remitente, mensaje;
  String distintivo;
  String chatId;
  String nombre;
  TextEditingController _busquedaTEC = new TextEditingController();

  @override
  void dispose(){
    _busquedaTEC.dispose();
    super.dispose();
  }

  QuerySnapshot searchSnapshot, contactosSnapshot;

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("chatsPrivados").doc(getChatId(Constants.miDistintivo, distintivo)).collection('categorias').orderBy('nombre', descending: false).limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget ListaCategorias() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:StreamBuilder(
        stream: getRealTimeData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if(snapshot.connectionState == ConnectionState.done)
            print('connection state done $snapshot');

          if(snapshot.connectionState == ConnectionState.none)
            print('connection state none $snapshot');

          if(snapshot.connectionState == ConnectionState.waiting){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height:  100,
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(_colorPrincipal),
                  ),
                ),
                SizedBox(height: 20,),
                Text('Cargando...',
                  style: TextStyle(
                    color: _colorPrincipal,
                    fontSize: 25,
                  ),
                )
              ],
            );
          } else{
            if(snapshot.connectionState == ConnectionState.active){
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    nombre = snapshot.data.docs[index].get('nombre');
                    return GestureDetector(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Categoría', style: TextStyle(color: _colorTextoDeshabilitado, fontSize: 20),),
                                      SizedBox(height: 5,),
                                      Text(nombre, style: TextStyle(color: _colorTextoPrincipal, fontSize: 25),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 300,
                            height: 0.2,
                            color: _colorTextoDeshabilitado,
                          )
                        ],
                      ),
                      onTap: (){
                        Navigator.pushNamed(context, '/mensajes-clasificados', arguments: MensajesClasificadosArgumentos(snapshot.data.docs[index].get('nombre'), distintivo));
                      },
                    );
                  },
                  shrinkWrap: true,
                ),
              );
            }
          }

          if(snapshot.hasError){
            print('snapshot has error $snapshot');
          } else{
            print('snapshot has not error $snapshot');
          }

          if(snapshot.hasData){
            print('snapshot has data $snapshot');
          } else{
            print('snapshot has not data $snapshot');
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height:  100,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: AlwaysStoppedAnimation<Color>(_colorPrincipal),
                ),
              ),
              SizedBox(height: 20,),
              Text('Cargando...',
                style: TextStyle(
                  color: _colorPrincipal,
                  fontSize: 25,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final MensajesCategoria _argumentos = ModalRoute.of(context).settings.arguments;
    distintivo = _argumentos.distintivo;
    chatId = getChatId(Constants.miDistintivo, distintivo);

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
        child: ListaCategorias(),
      )
    );
  }
}

class MensajesCategoria {
  final String distintivo;
  MensajesCategoria(this.distintivo);
}

String getChatId(String a, String b){
  if(a.compareTo(b) < 0)
    return '$a\_$b';
  else
    return '$b\_$a';
}