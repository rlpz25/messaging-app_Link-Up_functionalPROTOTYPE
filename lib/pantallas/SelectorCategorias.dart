import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/dialog.dart';
import 'package:flutter/material.dart';

import 'ChatPrivado.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class SelectorCategoria extends StatefulWidget {
  @override
  _SelectorCategoriaState createState() => _SelectorCategoriaState();
}

class _SelectorCategoriaState extends State<SelectorCategoria> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  String nombre;
  String distintivo;
  String mensaje;
  String chatId;
  String categoria;

  TextEditingController categoriaTEC = new TextEditingController();
  final categoriaKey = GlobalKey<FormState>();

  Stream<QuerySnapshot> getRealTimeData() async* {
    Query query = FirebaseFirestore.instance.collection("chatsPrivados").doc(chatId).collection('categorias').orderBy('nombre', descending: false).limit(20);
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
                    return Column(
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
                              SizedBox(width: 15,),
                              GestureDetector(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Icon(
                                    Icons.send_outlined,
                                    color: _colorFondo,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _colorPrincipal,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onTap: (){
                                  sendMessageMethodCategoria(Constants.miDistintivo, distintivo, chatId, mensaje, snapshot.data.docs[index].get('nombre'));
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 0.2,
                          color: _colorTextoDeshabilitado,
                        )
                      ],
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

  void agregarCategoria() {
    categoria = categoriaTEC.text;

    if(categoriaTEC.text.length > 20)
      showMaterialDialog(context, '¡Nombre muy largo!', 'El nombre de tu categoría debe ser de entre 2 y 20 caracteres');

    if(categoriaTEC.text.length < 2)
      showMaterialDialog(context, '¡Nombre muy corto!', 'El nombre de tu categoría debe ser de entre 2 y 20 caracteres');

    Map<String, dynamic> categoriaMap = {
      'nombre' : categoria,
      'creador' : Constants.miDistintivo,
    };

    if(categoriaTEC.text.length >= 2 && categoriaTEC.text.length <=20) {
      databaseMethods.crearCategoria(chatId, categoriaTEC.text, categoriaMap);

      categoriaTEC.clear();
    }
  }

  @override
  Widget build(BuildContext context) {

    final SelectorArgumentos _argumentos = ModalRoute.of(context).settings.arguments;

    distintivo = _argumentos.distintivo;
    chatId = getChatId(distintivo, Constants.miDistintivo);
    mensaje = _argumentos.mensaje;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Selecciona para enviar',
              style: TextStyle(
                fontSize: 25
              ),
          ),
        ),
      body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Expanded(
                child: ListaCategorias(),
              ),
              Container(
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
                                    key: categoriaKey,
                                    controller: categoriaTEC,
                                    style: TextStyle(
                                      color: _colorTextoPrincipal,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Asigna un nombre a tu categoria',
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
                              Icons.add,
                              color: _colorFondo,
                            )
                        ),
                        onTap: (){
                          agregarCategoria();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}

class SelectorArgumentos {
  final String distintivo;
  final String mensaje;
  SelectorArgumentos(this.distintivo, this.mensaje);
}

String getChatId(String a, String b){
  if(a.compareTo(b) < 0)
    return '$a\_$b';
  else
    return '$b\_$a';
}