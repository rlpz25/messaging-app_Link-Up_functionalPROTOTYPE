import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/pantallas/ChatPrivado.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'SelectorCategorias.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class ChatGrupal extends StatefulWidget {
  @override
  _ChatGrupalState createState() => _ChatGrupalState();
}

class _ChatGrupalState extends State<ChatGrupal> {

  String nombreG;
  String distintivoG;
  String remitente, destinatario, mensaje;
  Map<String, dynamic> mensajeMap;
  List<String> participantes;
  int mensajeId;

  final mensajeKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController mensajeTEC = new TextEditingController();
  QuerySnapshot querySnapshot, snapshotLista;

  sendMessageGrupo(){
    sendMessageMethodGrupo(Constants.miDistintivo, distintivoG, distintivoG, mensajeTEC.text, null);
    databaseMethods.getMensajesGrupo(distintivoG).then((value){
      querySnapshot = value;
      if(querySnapshot != null){
        print(querySnapshot.size);
        mensajeId = querySnapshot.size;
      } else {
        mensajeId = 0;
      }
      mensajeMap = {
        'identificador' : mensajeId,
        'remitente' : Constants.miDistintivo,
        'destinatario' : distintivoG,
        'mensaje' : mensajeTEC.text,
        'categoria' : 'GRAN CATEGORIA NULA VALOR POR 100000000000000000000000000000000000000000000000000000000000'
      };
      setState(() {
        mensajeTEC.clear();
      });
    });
  }


  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("chatsGrupales").doc(
        distintivoG).collection('mensajes').orderBy('identificador', descending: true).limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget ListaMensajesGrupo() {
    databaseMethods.getMensajes(distintivoG).then((val){
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
                          child: burbujaMensajeGrupo(mensaje, remitente),
                        );
                      }
                    }
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

    final ChatGrupalArgumentos _argumentos = ModalRoute.of(context).settings.arguments;
    nombreG = _argumentos.nombreG;
    distintivoG = _argumentos.distintivoG;

    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        centerTitle: false,
        leading: Row(
          children: [
            Spacer(),
            GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: _colorFondo,
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 10,),
          ],
        ),
        title: Text(
          nombreG,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            child: Icon(Icons.more_vert),
            onTap: (){
            },
          ),
          SizedBox(width: 10,),
          GestureDetector(
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/usuarios/user.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            onTap: (){
            },
            onDoubleTap: (){
            },
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
                child: ListaMensajesGrupo()
            ),
            GestureDetector(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: _colorFondo,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: _colorTextoDeshabilitado, width: 2),
                                color: _colorFondo,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 15,),
                                Expanded(
                                  child: TextFormField(
                                    key: mensajeKey,
                                    validator: (val){
                                      return null;
                                    },
                                    controller: mensajeTEC,
                                    style: TextStyle(
                                      color: _colorTextoPrincipal,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Escribe un Mensaje',
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
                              color: _colorTextoPrincipal,
                            ),
                            child: Icon(
                              Icons.send,
                              color: _colorFondo,
                            )
                        ),
                        onTap: (){
                          if(mensajeTEC.text == ''|| mensajeTEC.text == null){
                            print('todo meco');
                          } else {
                            sendMessageGrupo();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              onDoubleTap: (){
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatGrupalArgumentos {
  final String nombreG;
  final String distintivoG;
  ChatGrupalArgumentos(this.nombreG, this.distintivoG);
}

sendMessageMethodGrupo(String remitente, String destinatario, String distintivoG, String mensaje, String categoria){
  int mensajeId;
  Map<String, dynamic> mensajeMap;
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot snapshot;
  databaseMethods.getMensajesGrupo(distintivoG).then((value){
    snapshot = value;
    if(snapshot != null){
      mensajeId = snapshot.docs.length;
    } else {
      mensajeId = 0;
    }
    if(categoria == null){
      categoria = 'GRAN CATEGORIA NULA VALOR POR 100000000000000000000000000000000000000000000000000000000000';
    }
    mensajeMap = {
      'identificador' : mensajeId,
      'remitente' : remitente,
      'destinatario' : destinatario,
      'mensaje' : mensaje,
      'categoria' : categoria
    };
    databaseMethods.uploadMessageGrupo(distintivoG, mensajeId, mensajeMap);
  });
}
