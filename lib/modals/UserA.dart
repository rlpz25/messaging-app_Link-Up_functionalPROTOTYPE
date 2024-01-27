import 'package:flutter/cupertino.dart';

class UserA{

  final String distintivo;
  final String nombre;
  final String correo;
  UserA({@required this.distintivo, this.nombre, this.correo});

  factory UserA.fromJson(Map<String, dynamic> json){
    return UserA(
      distintivo: json["distintivo"],
      nombre: json["nombre"],
      correo: json["correo"],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'distintivo': distintivo,
      'nombre' : nombre,
      'correo' : correo,
    };
  }

}