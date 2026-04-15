import 'package:ejer3/patron_filtros.dart';

class FiltroArroba extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena){
    int posArroba = correo.indexOf("@");
    if (posArroba == -1 || posArroba == 0){
      return "Error: correo sin @ o sin nombre";
    }
    return null;
  }
}

class FiltroDominio extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena){
    int posArroba = correo.indexOf("@");
    if (posArroba == -1) {
      return "Error: correo sin @";
    }

    String dominio = correo.substring(posArroba + 1);

    if (dominio == "gmail.com" || dominio == "hotmail.com" || dominio == "correo.ugr.es" || dominio == "go.ugr.es"){
      return null;
    } else {
      return "Error: Dominio no válido";
    }
  }
}

class FiltroEmailExistente extends Filtro {
  FiltroEmailExistente(this.emailsRegistrados);
  final List<String> emailsRegistrados;

  @override
  String? ejecutar(String correo, String contrasena) {
    if (emailsRegistrados.contains(correo)) {
      return null;
    }
    return "Error: El email no está registrado";
  }
}