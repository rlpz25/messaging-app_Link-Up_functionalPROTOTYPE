import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/pantallas/ChatGrupal.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';

import 'ChatPrivado.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class Bandeja extends StatefulWidget {
  @override
  _BandejaState createState() => _BandejaState();
}

class _BandejaState extends State<Bandeja> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  String distintivo;
  String nombre;
  String correo;

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("usuarios").doc(Constants.miDistintivo).collection('conversaciones').limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget ListaConversacionesPrivadas() {
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
                    bool isRead = true;
                    distintivo = snapshot.data.docs[index].get('distintivo');
                    nombre = snapshot.data.docs[index].get('nombre');
                    correo = snapshot.data.docs[index].get('correo');
                    return GestureDetector(
                      child: tarjetaBandeja(nombre, distintivo, correo, isRead),
                      onTap: (){
                        Navigator.pushNamed(context, '/chat-privado', arguments: ChatPrivadoArgumentos(snapshot.data.docs[index].get('nombre'), snapshot.data.docs[index].get('distintivo'), snapshot.data.docs[index].get('correo')));
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
  Stream<QuerySnapshot> getRealTimeDataGrupos() async* {
    Query query = FirebaseFirestore.instance.collection("usuarios").doc(Constants.miDistintivo).collection('grupos').limit(20);
    yield* query.snapshots(includeMetadataChanges: true);
  }

  Widget ListaConversacionesGrupales() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child:StreamBuilder(
        stream: getRealTimeDataGrupos(),
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
                    bool isRead = true;
                    distintivo = snapshot.data.docs[index].get('distintivo');
                    nombre = snapshot.data.docs[index].get('nombre');
                    return GestureDetector(
                      child: tarjetaBandeja(nombre, distintivo, '', isRead),
                      onTap: (){
                        Navigator.pushNamed(
                            context,
                            '/chat-grupal',
                            arguments: ChatGrupalArgumentos(
                                snapshot.data.docs[index].get('nombre'),
                                snapshot.data.docs[index].get('distintivo'),
                            )
                        );
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
              Flexible(
                child: ListaConversacionesPrivadas(),
              ),
              Flexible(
                child: ListaConversacionesGrupales(),
              )
            ],
          )
      ),
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _colorPrincipal,
        ),
        child: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      children: [
                        Icon(
                          Icons.group_add,
                          color: _colorTextoDeshabilitado,
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Crear Grupo',
                          style: TextStyle(
                            color: _colorTextoPrincipal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/crear-grupo');
                  },
                )
            ),
          ],
          child: Icon(Icons.add, color: _colorFondo,),
        ),
      )
    );
  }
}