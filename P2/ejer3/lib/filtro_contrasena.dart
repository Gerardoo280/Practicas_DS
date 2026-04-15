import 'package:ejer3/patron_filtros.dart';

class FiltroLongitud extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena){
    if (contrasena.length < 8) return "Error: La contraseña debe tener mínimo 8 carácteres";
    if (contrasena.length > 30) return "Error: La contraseña no puede superar 30 caracteres";

    return null;
  }
}

class FiltroNumero extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena) {
    if (RegExp(r'[0-9]').hasMatch(contrasena)) {
      return null;
    }
    return "Error: La contraseña debe contener un carácter numérico";
  }
}

class FiltroCaracterEspecial extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena) {
    RegExp reg = RegExp(r'[a-zA-Z0-9]');
    for (int i = 0; i < contrasena.length; i++){
      String letra = contrasena[i];
      if (!reg.hasMatch(letra)) {
        return null;
      }
    }
    return "Error: La contraseña debe contener un carácter especial";
  }
}

class FiltroCorreoEnContrasena extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena) {
    String nombre = correo.substring(0,4);
    if (contrasena.contains(nombre)) {
      return "Error: La contraseña no puede contener el nombre del email";
    }

    return null;
  }
}

class FiltroMayuscula extends Filtro {
  @override
  String? ejecutar(String correo, String contrasena) {
    if (RegExp(r'[A-Z]').hasMatch(contrasena)) {
      return null;
    }
    return "Error: La contraseña debe contener al menos una mayúscula";
  }
}