import 'package:demo_linkup_mapp/pantallas/AgregarParticipante.dart';
import 'package:demo_linkup_mapp/pantallas/ChatGrupal.dart';
import 'package:demo_linkup_mapp/pantallas/Participantes.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/widgets/dialog.dart';
import 'package:demo_linkup_mapp/widgets/text_input.dart';
import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);
Color _colorSecundario = Color(0xffffd5c8);

class CrearGrupo extends StatefulWidget {
  @override
  _CrearGrupoState createState() => _CrearGrupoState();
}

class _CrearGrupoState extends State<CrearGrupo> {

  TextEditingController nombreGTEC = new TextEditingController();
  TextEditingController distintivoGTEC = new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final formKey = GlobalKey<FormState>();
  String distintivo;
  String nombreG, distintivoG;
  String correo;
  int _currentIndex = 0;
  bool isLoading = false;
  final tabs = [
    AgregarParticipante(),
    Participantes(),
  ];

  crearGrupo(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
      Constants.participantes.add(Constants.miDistintivo);
      if(Constants.participantes.length < 2)
        showMaterialDialog(context, '¡Pocos participantes!', 'Necesitas al menos 3 participantes para poder crear un grupo.');
      else{
        Map<String, dynamic> grupoMap ={
          'nombre' : nombreGTEC.text,
          'distintivo' : distintivoGTEC.text,
          'participantes' : Constants.participantes.toList()
        };
        databaseMethods.crearGrupo(distintivoGTEC.text, grupoMap);
        for(int i = 0; i < Constants.participantes.length; i++){
          databaseMethods.agregarGrupo(distintivoGTEC.text, Constants.participantes.toList()[i], grupoMap);
        }
        Constants.participantes.clear();
        Navigator.pushReplacementNamed(context, '/chat-grupal', arguments: ChatGrupalArgumentos(nombreGTEC.text, distintivoGTEC.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading ? null : AppBar(
        centerTitle: false,
        leading: FlatButton(
          child: Icon(
            Icons.arrow_back,
            color: _colorFondo,
          ),
          onPressed: (){
            Constants.participantes.clear();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Crea un grupo',
        ),
        actions: [
          GestureDetector(
            child:Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Center(
                child: Text(
                    'Crear'
                ),
              ),
            ),
            onTap: (){
              crearGrupo();
            },
          )
        ],
      ),
      body: isLoading ? Container(
          padding: EdgeInsets.all(20),
          color: _colorFondo,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  'Link-Up',
                  style: TextStyle(
                    fontSize: 70,
                    color: _colorTextoPrincipal,
                  ),
                ),
                SizedBox(height: 20,),
                Image.asset(
                  'assets/images/link-up-media/logo.png',
                  width: 300,
                  color: _colorTextoPrincipal,
                ),
                Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    children: [
                      Container(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(_colorPrincipal),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        child: Text(
                          'Iniciando Sesión...',
                          style: TextStyle(color: _colorPrincipal),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ) : Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val){
                            return nombreGTEC.text.length > 20 || nombreGTEC.text.length < 5 ? 'El nombre del grupo debe contener entre 5 y 20 caracteres.' : null;
                          },
                          controller: nombreGTEC,
                          decoration: campoDatos(
                              'Nombre del Grupo:',
                              Icon(Icons.group),
                              false,
                              null
                          ),
                        ),
                        TextFormField(
                          validator: (val){
                            return distintivoGTEC.text.length > 20 || distintivoGTEC.text.length < 6 ? 'El distintivo del grupo debe contener entre 6 y 20 caracteres.' : null;
                          },
                          controller: distintivoGTEC,
                          decoration: campoDatos(
                              'Distintivo del Grupo:',
                              Icon(Icons.alternate_email),
                              false,
                              null
                          ),
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                child: tabs[_currentIndex],
                onHorizontalDragEnd: (val){
                  if(_currentIndex == 0)
                    setState(() {
                      _currentIndex = 1;
                    });
                  else
                    setState(() {
                      _currentIndex = 0;
                    });
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _colorFondo,
        currentIndex: _currentIndex,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Agregar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Participantes'
          ),
        ],
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
