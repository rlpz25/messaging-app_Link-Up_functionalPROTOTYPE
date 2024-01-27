import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/auth.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/services/helper_functions.dart';
import 'package:demo_linkup_mapp/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_statusbarcolor/flutter_statusbarcolor.dart";

import 'package:demo_linkup_mapp/widgets/text_input.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorSecundario = Color(0xffffd5c8);
Color _colorFondo = Color(0xffeff0ef);
Color _colorTextoPrincipal = Color(0xff121215);
Color _colorTextoDeshabilitado = Color(0x8c121215);

class RegistroUsuario extends StatefulWidget {
  @override
  _RegistroUsuarioState createState() => _RegistroUsuarioState();
}

class _RegistroUsuarioState extends State<RegistroUsuario> {

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot, distintivoQuery, correoQuery;

  TextEditingController _distintivoTEC = new TextEditingController();
  TextEditingController _correoTEC = new TextEditingController();
  TextEditingController _claveTEC = new TextEditingController();
  TextEditingController _confClaveTEC = new TextEditingController();
  TextEditingController _nombreP = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){

      Map<String, dynamic> userInfo = {
        'distintivo' : _distintivoTEC.text,
        'correo' : _correoTEC.text,
        'nombre' : _nombreP.text,
      };

      setState(() {
        isLoading = true;
      });

      _databaseMethods.getUserDistintivo(_distintivoTEC.text).then((value){
        distintivoQuery = value;
        _databaseMethods.getUserCorreo(_correoTEC.text).then((val){
          correoQuery = val;
          if(distintivoQuery != null || correoQuery != null){
            print('1');
            if(distintivoQuery.size != 0 || correoQuery.size != 0){
              print('2');
              if(distintivoQuery.size != 0 && correoQuery.size != 0){
                print('3a');
                showMaterialDialog(context, 'Datos ya registrados :o', 'Este correo y distintivo coinciden con otra cuenta en nuestra base de datos, Intenta Iniciar Sesión en "Inicia Sesión aquí" en la pantalla anterior.');
              } else{
                if(distintivoQuery.size != 0){
                  print('3b');
                  showMaterialDialog(context, 'Distintivo registrado T-T', 'Este distintivo coincide con otra cuenta en nuestra base de datos, elige un distintivo diferente :(');
                }
                if(correoQuery.size != 0){
                  print('3c');
                  showMaterialDialog(context, 'Correo registrado :o', 'Este correo coincide con otra cuenta en nuestra base de datos, Intenta Iniciar Sesión en "Inicia Sesión aquí" en la pantalla anterior.');
                }
              }
              setState(() {
                isLoading = false;
              });
            } else {
              print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');
              try{
                _authMethods.signUpWithEmailAndPassword(_correoTEC.text, _confClaveTEC.text).then((val){
                  /*print('${val.uid}');*/
                  if(val != null){
                    _databaseMethods.uploadUserInfo(_distintivoTEC.text ,userInfo);
                    HelperFunctions.limpiarPreferencias();
                    HelperFunctions.saveCorreo(_correoTEC.text);
                    HelperFunctions.saveDistintivoSP(_distintivoTEC.text);
                    HelperFunctions.saveNombre(_nombreP.text);
                    HelperFunctions.saveUserSP(true);
                    Constants.miNombre = _nombreP.text;
                    Constants.miDistintivo = _distintivoTEC.text;
                    Constants.miCorreo = _correoTEC.text;
                    Navigator.pushReplacementNamed(context, '/inicio');
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                  }
                });
              }catch(e){
                print(e.toString());
              }
            }
          } else {
            showMaterialDialog(context, 'Error inesperado x.x', 'Puede que este correo ya esté registrado en nuestra base de datos, intenta con uno distinto.\nSi el error persiste, contacta con Soporte.');
            setState(() {
              isLoading = false;
            });
          }
        });
      });
    }
  }

  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(_colorPrincipal);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarColor(_colorFondo);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);

    return Scaffold(
      appBar: isLoading ? null : AppBar(
        backgroundColor: _colorFondo,
        title: Text(
          'Link-Up',
          style: TextStyle(
            color: _colorTextoPrincipal,
            fontSize: 25,
          ),
        ),
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
                          'Registrando Usuario...',
                          style: TextStyle(color: _colorPrincipal),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
      ) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 30
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: 20
                ),
                child: Image.asset(
                  "assets/images/link-up-media/logo.png",
                  height: 100,
                  color: _colorTextoPrincipal,
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val){
                        return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val) ? null : "Por favor, Ingresa una direccion de Correo Valida.";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _correoTEC,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration: campoDatos(
                        'Ingresa tu dirección de Correo',
                        Icon(
                          Icons.mail,
                          color: _colorTextoDeshabilitado,
                        ),
                        false,
                        null,
                      ),
                    ),
                    TextFormField(
                      validator: (val){
                        return val.isEmpty ? 'Escribe tu nombre' : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _nombreP,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration: campoDatos(
                        'Escribe tu nombre',
                        Icon(
                          Icons.person,
                          color: _colorTextoDeshabilitado,
                        ),
                        false,
                        null,
                      ),
                    ),
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9\-_.']*$").hasMatch(val) && val.length >= 6 && val.length <= 20 ?  null : 'Tu Distintivo debe tener entre 6 y 20 caracteres\nPuede contener los siguientes caracteres:   - \' _ .';
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _distintivoTEC,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration: campoDatos(
                        'Crea tu Distintivo',
                        Icon(
                          Icons.alternate_email,
                          color: _colorTextoDeshabilitado,
                        ),
                        false,
                        null,
                      ),
                    ),
                    TextFormField(
                      validator: (val){
                        return val.length > 20 || val.length < 5 ? "Tu clave debe contener entre 5 y 20 caracteres.\nPor favor, ingresa una Clave valida." : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _claveTEC,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration:campoDatos(
                          'Crea una Clave',
                          Icon(
                            Icons.lock_open,
                            color: _colorTextoDeshabilitado,
                          ),
                          true,
                          PasswordVisible(_isVisible)),
                      obscureText: !_isVisible,
                    ),
                    TextFormField(
                      validator: (val){
                        return _confClaveTEC.text != _claveTEC.text ? "Las claves no coinciden.\nPor favor, revisa tu Clave." : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _confClaveTEC,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration: campoDatos(
                          'Confirma tu Clave',
                          Icon(
                            Icons.lock_open,
                            color: _colorTextoDeshabilitado,
                          ),
                          true,
                          PasswordVisible(_isVisible)
                      ),
                      obscureText: !_isVisible,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _colorPrincipal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Regístrate",
                    style: TextStyle(
                        color: _colorFondo,
                        fontSize: 18
                    ),
                  ),
                ),
                onTap: () {
                  signMeUp();
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _colorSecundario,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          "assets/images/social-media-logos/facebook.png",
                          width: 30,
                        ),
                        Flexible(
                          child: Center(
                            child: Text(
                              "Regístrate con Facebook",
                              style: TextStyle(
                                color: _colorTextoPrincipal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                onTap: () {
                  showMaterialDialog(context, 'Muy pronto...', 'Estamos trabajando en ello.');
                },
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _colorSecundario,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Image.asset(
                          "assets/images/social-media-logos/google.png",
                          width: 30,
                        ),
                        Flexible(
                          child: Center(
                            child: Text(
                              "Regístrate con Google",
                              style: TextStyle(
                                color: _colorTextoPrincipal,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                onTap: () {
                  showMaterialDialog(context, 'Muy pronto...', 'Estamos trabajando en ello.');
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una Cuenta? ',
                    style: TextStyle(
                      color: _colorTextoPrincipal,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Inicia Sesión aquí.',
                      style: TextStyle(
                        color: _colorPrincipal,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/inicio-sesion');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleVisible() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  // ignore: non_constant_identifier_names
  GestureDetector PasswordVisible(bool isVisible) {
    if (isVisible == true)
      return GestureDetector(
        child: Icon(
          Icons.visibility,
          color: _colorPrincipal,
        ),
        onTap: toggleVisible,
      );
    else
      return GestureDetector(
        child: Icon(
            Icons.visibility_off,
            color: _colorTextoDeshabilitado,
        ),
        onTap: toggleVisible,
      );
  }
}