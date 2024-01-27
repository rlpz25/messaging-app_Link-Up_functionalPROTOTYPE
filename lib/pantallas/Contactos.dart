import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/pantallas/ChatPrivado.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';
import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);

class Contactos extends StatefulWidget {
  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  String distintivo;
  String nombre;
  String correo;

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

    Navigator.pushNamed(
        context,
        '/chat-privado',
        arguments: ChatPrivadoArgumentos(
            nombre,
            distintivo,
            correo
        )
    );
  }

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("usuarios").doc(Constants.miDistintivo).collection('contactos').orderBy('nombre', descending: false).limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }
  
  Widget ListaContactos() {
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
                    distintivo = snapshot.data.docs[index].get('distintivo');
                    nombre = snapshot.data.docs[index].get('nombre');
                    correo = snapshot.data.docs[index].get('correo');
                    return GestureDetector(
                      child: tarjetaContacto(nombre, distintivo),
                      onTap: (){
                        String distintivo = snapshot.data.docs[index].get('distintivo');
                        String nombre = snapshot.data.docs[index].get('nombre');
                        String correo = snapshot.data.docs[index].get("correo");
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ListaContactos(),
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_search),
        onPressed: (){
          Navigator.pushNamed(context, '/busqueda-amigo');
        },
      ),
    );
  }
}
