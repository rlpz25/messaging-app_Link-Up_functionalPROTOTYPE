import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_linkup_mapp/modals/UserA.dart';

class FirestoreService {

  FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<UserA>> getUsers(String d){
    return _db
      .collection('usuarios')
      .where('nombre', isEqualTo: d)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => UserA.fromJson(doc.data()))
      .toList());
  }

  Future<void> setUsuario(UserA usuario){
    var options = SetOptions(merge: true);

    return _db
        .collection('usuarios')
        .doc(usuario.distintivo)
        .set(usuario.toMap(), options);
  }

  Future<void> removeUser(String distintivo){
    return _db
      .collection('usuarios')
      .doc(distintivo)
      .delete();
  }

}