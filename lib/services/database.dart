import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserDistintivo(String d) async {
    return await FirebaseFirestore
        .instance
        .collection("usuarios")
        .where('distintivo', isEqualTo: d)
        .get();
  }

  getUserDistintivoCompletarOrdenar(String d) async {
    return await FirebaseFirestore
        .instance
        .collection("usuarios")
        .where('distintivo', isGreaterThanOrEqualTo: d)
        .orderBy('distintivo')
        .get();
  }

  getUserDistintivoImpreciso(String d) async {
    return await FirebaseFirestore
        .instance
        .collection("usuarios")
        .where('distintivo', isNotEqualTo: d)
        .get();
  }

  getContactos(String distintivo) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('contactos')
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getUserCorreo(String c) async {
    return await FirebaseFirestore
        .instance
        .collection("usuarios")
        .where('correo', isEqualTo: c)
        .get();
  }

  getMensajes(chatId) async {
    return await FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('mensajes')
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getMensajesGrupo(distintivoG) async {
    return await FirebaseFirestore
        .instance
        .collection('chatsGrupales')
        .doc(distintivoG)
        .collection('mensajes')
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getConversacion(String distintivo, chatId) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('conversaciones')
        .where('chatId', isEqualTo: chatId)
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getMensajesCategoria(String chatId, String c) async {
    return await FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('mensajes')
        .where('categoria', isEqualTo: c)
        .get()
        .catchError((e){
          print(e.toString());
    });
  }

  getCategoriasUsuario(chatId, mensajeId)async {
    return await FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('mensajes')
        .doc(mensajeId)
        .collection('categorias')
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  getCategoriasChat(String chatId) async {
    return await FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('categorias')
        .get()
        .catchError((e){
      print(e.toString());
    });
  }

  createChatPrivado(String chatId, chatMap){
    FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .set(chatMap)
        .catchError((e){
      print(e.toString());
    });
  }

  crearGrupo(String distintivoG, grupoMap){
    FirebaseFirestore
        .instance
        .collection('chatsGrupales')
        .doc(distintivoG)
        .set(grupoMap)
        .catchError((e){
       print(e.toString());
    });
  }

  uploadUserInfo(String distintivo, userMap){
    FirebaseFirestore
        .instance
        .collection("usuarios")
        .doc(distintivo)
        .set(userMap)
        .catchError((e){
      print(e.toString());
    });
  }

  uploadMessage(String chatId, int mensajeId, mensajeMap){
    FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('mensajes')
        .doc(mensajeId.toString())
        .set(mensajeMap)
        .catchError((e){
      print(e.toString());
    });
  }

  uploadMessageGrupo(String distintivoG, int mensajeId, mensajeMap){
    FirebaseFirestore
        .instance
        .collection('chatsGrupales')
        .doc(distintivoG)
        .collection('mensajes')
        .doc(mensajeId.toString())
        .set(mensajeMap)
        .catchError((e){
      print(e.toString());
    });
  }

  crearCategoria(String chatId, String categoriaId, categoriaMap){
    FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('categorias')
        .doc(categoriaId)
        .set(categoriaMap)
        .catchError((e){
      print(e.toString());
    });
  }

  uploadCategoria(chatId, mensajeId, categoriaId, categoriaMap){
    FirebaseFirestore
        .instance
        .collection('chatsPrivados')
        .doc(chatId)
        .collection('mensajes')
        .doc(mensajeId)
        .collection('categorias')
        .doc(categoriaId)
        .set(categoriaMap)
        .catchError((e){
      print(e.toString());
    });
  }

  agregarContacto(String distintivo, String contacto, contactoMap) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('contactos')
        .doc(contacto)
        .set(contactoMap)
        .catchError((e){
       print(e.toString());
    });
  }

  agregarConversacion(String chatId, String distintivo,conversacionMap) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('conversaciones')
        .doc(chatId)
        .set(conversacionMap)
        .catchError((e){
      print(e.toString());
    });
  }

  agregarConversacionOtro(String chatId, String distintivo,conversacionMap) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('conversaciones')
        .doc(chatId)
        .set(conversacionMap)
        .catchError((e){
      print(e.toString());
    });
  }

  agregarGrupo(String distintivoG, String distintivo, grupoMap) async {
    return await FirebaseFirestore
        .instance
        .collection('usuarios')
        .doc(distintivo)
        .collection('grupos')
        .doc(distintivoG)
        .set(grupoMap)
        .catchError((e){
      print(e.toString());
    });
  }

}