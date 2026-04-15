class Autenticacion {
  String autenticar(String correo){
    return "Autenticacion completada con éxito para $correo";
  }
}

abstract class Filtro {
  String? ejecutar(String correo, String contrasena);
}

class Cadena {
  final List<Filtro> filtros = [];
  Autenticacion? objetivo;

  void agregarFiltro(Filtro filtro){
    filtros.add(filtro);
  }

  void establecerObjetivo(Autenticacion objet){
    objetivo = objet;
  }

  String ejecutar(String correo, String contrasena){
    for(int i = 0; i < filtros.length; i++) {
      Filtro filtro = filtros[i];
      String? error = filtro.ejecutar(correo, contrasena);
      if(error != null) return error;
    }

    if (objetivo != null){
      return objetivo?.autenticar(correo) ?? "Login correcto";
    }
    return "Error: no existe objetivo";
  }
}

class GestorFiltros {
  GestorFiltros(this.objetivo) {
    cadena.establecerObjetivo(objetivo);
  }

  final Cadena cadena = Cadena();
  final Autenticacion objetivo;

  void agregarFiltro(Filtro filtro){
    cadena.agregarFiltro(filtro);
  }

  String procesarPeticion(String correo, String contrasena) {
    return cadena.ejecutar(correo, contrasena);
  }
}

class Client {
  String? intentarAutenticacion(String correo, String contrasena, GestorFiltros gestorFiltros) {
    return gestorFiltros.procesarPeticion(correo, contrasena);
  }
}