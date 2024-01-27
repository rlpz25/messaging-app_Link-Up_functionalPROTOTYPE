import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/auth.dart';
import 'package:demo_linkup_mapp/services/database.dart';
import 'package:demo_linkup_mapp/services/helper_functions.dart';
import 'package:demo_linkup_mapp/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import 'package:demo_linkup_mapp/widgets/text_input.dart';

  Color _colorPrincipal = Color(0xfffe5722);
  Color _colorSecundario = Color(0xffffd5c8);
  Color _colorFondo = Color(0xffeff0ef);
  Color _colorTextoPrincipal = Color(0xff121215);
  Color _colorTextoDeshabilitado = Color(0x8c121215);

class InicioSesion extends StatefulWidget {
  @override
  _InicioSesionState createState() => _InicioSesionState();
}

class _InicioSesionState extends State<InicioSesion> {

  String errorMessage = '';

  bool _isVisible = false;
  bool isLoading = false;

  AuthMethods _authMethods = new AuthMethods();
  DatabaseMethods _databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  signIn(){
    if(formKey.currentState.validate()){

      setState(() {
        isLoading = true;
      });

      _databaseMethods.getUserCorreo(_correoTEC.text).then((val){
        if(val != null){
          if(val.size != 0){
            searchSnapshot = val;
            HelperFunctions.limpiarPreferencias();
            HelperFunctions.saveCorreo(searchSnapshot.docs[0].get('correo'));
            HelperFunctions.saveDistintivoSP(searchSnapshot.docs[0].get('distintivo'));
            HelperFunctions.saveNombre(searchSnapshot.docs[0].get('nombre'));
            Constants.miNombre = searchSnapshot.docs[0].get('nombre');
            Constants.miDistintivo = searchSnapshot.docs[0].get('distintivo');
            Constants.miCorreo = searchSnapshot.docs[0].get('correo');
            try{
              _authMethods.signInWithEmailAndPassword(_correoTEC.text, _claveTEC.text).then((val){
                //print("${val.uid}");
                if(val != null){
                  HelperFunctions.saveUserSP(true);
                  Navigator.pushReplacementNamed(context, '/inicio');
                }else{
                  setState(() {
                    isLoading = false;
                  });
                  showMaterialDialog(context, 'Revisa tus datos', 'Contraseña incorrecta, revisa tu contraseña.');
                }
              }).catchError((e){});
            }catch(e) {
              print('EEEEEEEEEEEEEEERRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRR');
              switch (e.code) {
                case "ERROR_INVALID_EMAIL":
                  errorMessage = "Esto no es una dirección de Correo Válida.";
                  break;
                case "ERROR_WRONG_PASSWORD":
                  errorMessage = "Contraseña incorrecta, por favor verifica tus datos.";
                  break;
                case "ERROR_USER_NOT_FOUND":
                  errorMessage = "Usuario no registrado, Intenta en \'Regístrate aquí\'.";
                  break;
                case "ERROR_USER_DISABLED":
                  errorMessage = "Esta cuenta ha sido desactivada, contacta con Soporte.";
                  break;
                case "ERROR_TOO_MANY_REQUESTS":
                  errorMessage = "Demasiados Intentos, Prueba de nuevo más tarde.";
                  break;
                case "ERROR_OPERATION_NOT_ALLOWED":
                  errorMessage = "Verifica tus datos, ingresa tu Correo y Contraseña.";
                  break;
                default:
                  errorMessage = "Error indefinido. Contacte a Soporte";
              }
              switch (e.code) {
                case "ERROR_EMAIL_ALREADY_IN_USE":
                case "account-exists-with-different-credential":
                case "email-already-in-use":
                  return "Email already used. Go to login page.";
                  break;
                case "ERROR_WRONG_PASSWORD":
                case "wrong-password":
                  return "Wrong email/password combination.";
                  break;
                case "ERROR_USER_NOT_FOUND":
                case "user-not-found":
                  return "No user found with this email.";
                  break;
                case "ERROR_USER_DISABLED":
                case "user-disabled":
                  return "User disabled.";
                  break;
                case "ERROR_TOO_MANY_REQUESTS":
                case "operation-not-allowed":
                  return "Too many requests to log into this account.";
                  break;
                case "ERROR_OPERATION_NOT_ALLOWED":
                case "operation-not-allowed":
                  return "Server error, please try again later.";
                  break;
                case "ERROR_INVALID_EMAIL":
                case "invalid-email":
                  return "Email address is invalid.";
                  break;
                default:
                  return "Login failed. Please try again.";
                  break;
              }
            }
          } else {
            showMaterialDialog(context, 'Usuario no registrado', 'Estos datos no coinciden en nuestra base de datos, revisa tu correo o prueba "Regístrate aquí" en la pantalla anterior.');

            setState(() {
              isLoading = false;
            });
          }
        }
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController _correoTEC = new TextEditingController();
  TextEditingController _claveTEC = new TextEditingController();

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
                        return RegExp(r"^[a-zA-Z0-9.!#$%^&*_]+@[a-zA-Z0-9.!#$%^&*_]+.[a-zA-Z0-9.!#$%^&*_]").hasMatch(val) ? null : "Por favor, Ingresa una direccion de Correo Valida.";
                      },
                      controller: _correoTEC,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration: campoDatos(
                        'Correo',
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
                        return val.length > 15 || val.length < 5 ? "Tu clave debe contener entre 5 y 15 caracteres. Por favor, ingresa una Clave valida." : null;
                      },
                      controller: _claveTEC,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(
                        color: _colorTextoPrincipal,
                      ),
                      decoration:campoDatos(
                          'Clave',
                          Icon(
                            Icons.lock,
                            color: _colorTextoDeshabilitado,
                          ),
                          true,
                          PasswordVisible(_isVisible)),
                      obscureText: !_isVisible,
                    )
                  ],
                ),
              ),
              errorMessage != '' ? SizedBox(height: 5,) : Container(),
              errorMessage != '' ? Text(errorMessage) : Container(),
              errorMessage != '' ? SizedBox(height: 5,) : SizedBox(height: 10,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    child: Text(
                      "¿Olvidaste tu Contraseña?",
                      style: TextStyle(
                        color:  _colorPrincipal,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: (){
                      showMaterialDialog(context, 'Muy pronto...', 'Estamos trabajando en ello.');
                    },
                  ),
                ),
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
                    color: _colorPrincipal,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Inicia Sesión",
                    style: TextStyle(
                        color: _colorFondo,
                        fontSize: 18
                    ),
                  ),
                ),
                onTap: (){
                  signIn();
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
                            "Inicia Sesión con Facebook",
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
                onTap: (){
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
                            "Inicia Sesión con Google",
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
                onTap: (){
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
                    '¿No tienes una Cuenta? ',
                    style: TextStyle(
                      color:  _colorTextoPrincipal,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'Regístrate aquí.',
                      style: TextStyle(
                        color:  _colorPrincipal,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, '/registro-usuario');
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

  void toggleVisible(){
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
          color: _colorPrincipal
        ),
        onTap: toggleVisible,
      );
    else
      return GestureDetector(
        child: Icon(
          Icons.visibility_off,
          color: _colorTextoDeshabilitado
        ),
        onTap: toggleVisible,
      );
  }
}