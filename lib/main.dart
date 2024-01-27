import 'package:demo_linkup_mapp/pantallas/Ajustes.dart';
import 'package:demo_linkup_mapp/pantallas/ChatGrupal.dart';
import 'package:demo_linkup_mapp/pantallas/CrearGrupo.dart';
import 'package:demo_linkup_mapp/pantallas/MensajesClasificados.dart';
import 'package:demo_linkup_mapp/pantallas/Categorias.dart';
import 'package:demo_linkup_mapp/pantallas/PantallaEspera.dart';
import 'package:demo_linkup_mapp/pantallas/ChatPrivado.dart';
import 'package:demo_linkup_mapp/pantallas/Inicio.dart';
import 'package:demo_linkup_mapp/pantallas/InicioSesion.dart';
import 'package:demo_linkup_mapp/pantallas/RegistroUsuario.dart';
import 'package:demo_linkup_mapp/pantallas/Busqueda.dart';
import 'package:demo_linkup_mapp/pantallas/BuscarAmigo.dart';
import 'package:demo_linkup_mapp/pantallas/SelectorCategorias.dart';
import 'package:demo_linkup_mapp/services/Constants.dart';
import 'package:demo_linkup_mapp/services/helper_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Color _colorPrincipal = Color(0xfffe5722);
Color _colorFondo = Color(0xffeff0ef);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isUserLogged = false;
  bool isLoading = true;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getUserInfo(){
    HelperFunctions.getNombreSP().then((value){
      Constants.miNombre = value;
    });
    HelperFunctions.getDistintivoSP().then((value){
      Constants.miDistintivo = value;
    });
    HelperFunctions.getCorreoSP().then((value){
      Constants.miCorreo = value;
    });
    setState(() {
      isLoading = false;
    });
  }

  getLoggedInState() async {
    await HelperFunctions.getUserSP().then((value){
      if(value != null){
        isUserLogged = value;
        getUserInfo();
      } else {
        isUserLogged = false;
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Algo salio mal',
            home: Scaffold(
              body: Container(
                child: Center(
                  child: Text(
                    'Algo Salio mal :(',
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Link-Up Demo',
            theme: ThemeData(
              primaryColor: Colors.deepOrange,
              primarySwatch: Colors.deepOrange,
              scaffoldBackgroundColor: _colorFondo,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                elevation: 0,
                backgroundColor: _colorPrincipal,
                foregroundColor: _colorFondo,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                textTheme: TextTheme(
                ),
                color: _colorPrincipal,
                iconTheme: IconThemeData(
                    color: _colorFondo
                ),
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: _colorPrincipal,
                selectionColor: _colorPrincipal,
                selectionHandleColor: _colorPrincipal,
              ),
              focusColor: _colorPrincipal,
              fontFamily: 'Ubuntu',
            ),
            themeMode: ThemeMode.dark,
            home: isLoading ? PantallaEspera() : isUserLogged ? Inicio() : InicioSesion(),
            routes: {
              '/inicio-sesion' : (context) => InicioSesion(),
              '/registro-usuario' : (context) => RegistroUsuario(),
              '/inicio' : (context) => Inicio(),
              '/ajustes' : (context) => Ajustes(),
              '/busqueda' : (context) => Busqueda(),
              '/busqueda-amigo' : (context) => BuscarAmigo(),
              '/chat-privado' : (context) => ChatPrivado(),
              '/selector' : (context) => SelectorCategoria(),
              '/mensajes-categoria' : (context) => Categorias(),
              '/mensajes-clasificados' : (context) => MensajesClasificados(),
              '/crear-grupo' : (context) => CrearGrupo(),
              '/chat-grupal' : (context) => ChatGrupal(),
            },
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cargando',
          home: PantallaEspera(),
        );
      },
    );

  }
}