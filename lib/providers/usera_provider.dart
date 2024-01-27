import 'package:demo_linkup_mapp/modals/UserA.dart';
import 'package:demo_linkup_mapp/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class UserAProvider with ChangeNotifier{
  final firestoreService = FirestoreService();
  String _nombre;
  String _distintivo;
  String _correo;

  var uuid = Uuid();

  String get nombre => _nombre;
  String get distintivo => _distintivo;
  String get correo => _correo;

  Stream<List<UserA>> get usuarios => firestoreService.getUsers(_distintivo);

  set changeNombre(String nombre){
    _nombre = nombre;
    notifyListeners();
  }

  set changeDistintivo(String distintivo){
    _distintivo = distintivo;
    notifyListeners();
  }

  set changeCorreo(String correo){
    _correo = correo;
    notifyListeners();
  }

  loadAll(UserA userA){
    if(userA != null){
      _distintivo = userA.distintivo;
      _nombre = userA.nombre;
      _correo = userA.correo;
    } else {
      _distintivo = null;
      _nombre = null;
      _correo = null;
    }
  }

  saveUserA(){
    if(_distintivo == null){
      var newUserA = UserA(distintivo: _distintivo, nombre: _nombre, correo: _correo);
      firestoreService.setUsuario(newUserA);
    }else{
      var updateUsuarioA = UserA(distintivo: _distintivo, nombre: _nombre, correo: _correo);
      firestoreService.setUsuario(updateUsuarioA);
    }
  }

  removeUsuarioA(String distintivo){
    firestoreService.removeUser(distintivo);
  }

}