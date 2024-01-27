import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/tarjetas.dart';
import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);
Color _colorSecundario = Color(0xffffd5c8);

class Participantes extends StatefulWidget {
  @override
  _ParticipantesState createState() => _ParticipantesState();
}

class _ParticipantesState extends State<Participantes> {

  TextEditingController nombreTEC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  String distintivo;
  String nombre;
  String correo;

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
                    if(distintivo == Constants.miDistintivo){
                      return Container();
                    }else{
                      if(Constants.participantes.contains(distintivo)){
                        return GestureDetector(
                          child: tarjetaContacto(nombre, distintivo),
                          onTap: (){
                            setState(() {
                              Constants.participantes.remove(snapshot.data.docs[index].get('distintivo'));
                            });
                          },
                        );
                      }else{
                        return Container();
                      }
                    }
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
    return Column(
      children: [
        Container (
          padding: EdgeInsets.symmetric(horizontal: 15),
          child:Text(
            'Selecciona los usuarios que quieras eliminar del grupo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: _colorTextoDeshabilitado,
            ),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(child: ListaContactos()),
      ],
    );
  }
}
