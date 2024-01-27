import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/auth.dart';
import 'package:demo_linkup_mapp/services/helper_functions.dart';
import 'package:demo_linkup_mapp/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class Ajustes extends StatefulWidget {
  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {

  AuthMethods _authMethods = new AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Link-Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10
          ),
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage(
                  'assets/images/usuarios/user.jpg'
                  ),
                ),
                onTap: null,
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Spacer(),
                  Text(
                    Constants.miNombre,
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Icon(Icons.person, size: 35,),
                  SizedBox(width: 10,),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(),
                          children: [
                            TextSpan(
                              text: 'Nombre de perfil\n',
                              style: TextStyle(
                                color: _colorTextoPrincipal,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: Constants.miNombre,
                              style: TextStyle(
                                fontSize: 16,
                                color: _colorTextoDeshabilitado,
                              ),
                            ),
                          ]
                      )
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Icon(Icons.alternate_email, size: 35,),
                  SizedBox(width: 10,),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(),
                      children: [
                        TextSpan(
                          text: 'Distintivo\n',
                          style: TextStyle(
                            color: _colorTextoPrincipal,
                            fontSize: 18,
                          ),
                        ),
                        TextSpan(
                          text: Constants.miDistintivo,
                          style: TextStyle(
                            fontSize: 16,
                            color: _colorTextoDeshabilitado,
                          ),
                        ),
                      ]
                    )
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 30,),
              Row(
                children: [
                  Icon(Icons.mail, size: 35,),
                  SizedBox(width: 10,),
                  RichText(
                      text: TextSpan(
                          style: TextStyle(),
                          children: [
                            TextSpan(
                              text: 'Correo electrónico\n',
                              style: TextStyle(
                                color: _colorTextoPrincipal,
                                fontSize: 18,
                              ),
                            ),
                            TextSpan(
                              text: Constants.miCorreo,
                              style: TextStyle(
                                fontSize: 16,
                                color: _colorTextoDeshabilitado,
                              ),
                            ),
                          ]
                      )
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 50,),
              GestureDetector(
                onTap: (){
                  _authMethods.signOut().then((value){
                    Navigator.pop(context);
                    HelperFunctions.limpiarPreferencias();
                    HelperFunctions.saveUserSP(false);
                    HelperFunctions.saveNombre('');
                    HelperFunctions.saveDistintivoSP('');
                    HelperFunctions.saveCorreo('');
                    Navigator.pushReplacementNamed(context, '/inicio-sesion');
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          showMaterialDialog(context, 'Muy pronto...', 'Estamos trabajando en ello.');
        },
      ),
    );
  }
}
