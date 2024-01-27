import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/pantallas/BuscarAmigo.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);

class MensajesClasificados extends StatefulWidget {
  @override
  _MensajesClasificadosState createState() => _MensajesClasificadosState();
}

class _MensajesClasificadosState extends State<MensajesClasificados> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController mensajeTEC = new TextEditingController();
  QuerySnapshot querySnapshot, snapshotLista;
  String nombre, distintivo, chatId, remitente, mensaje;

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("chatsPrivados").doc(
        chatId).collection('mensajes').orderBy('identificador', descending: true).limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget ListaMensajes() {
    databaseMethods.getMensajes(chatId).then((val){
      querySnapshot = val;
    });
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
                    remitente = snapshot.data.docs[index].get('remitente');
                    mensaje = snapshot.data.docs[index].get('mensaje');
                    if(nombre == snapshot.data.docs[index].get('categoria')){
                      if (remitente == Constants.miDistintivo) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: burbujaMensajeUsuarioActual(mensaje),
                        );
                      } else {
                        if(remitente == 'system'){
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: burbujaMensajeSistema(mensaje),
                          );
                        } else {
                          return Container(
                            padding: EdgeInsets.symmetric(vertical: 3),
                            child: burbujaMensajeUsuarioExterno(mensaje),
                          );
                        }
                      }
                    }
                    return Container();
                  },
                  shrinkWrap: true,
                  dragStartBehavior: DragStartBehavior.down,
                  reverse: true,
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

    final MensajesClasificadosArgumentos _argumentos = ModalRoute.of(context).settings.arguments;
    nombre = _argumentos.nombre;
    distintivo = _argumentos.distintivo;
    chatId = getChatId(Constants.miDistintivo, distintivo);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mensajes de ' + nombre),
      ),
      body: ListaMensajes(),
    );
  }
}

class MensajesClasificadosArgumentos{
  final String nombre;
  final String distintivo;
  MensajesClasificadosArgumentos(this.nombre, this.distintivo);
}