import 'Servicioturistico.dart';

class Paquete implements Servicioturistico{
  final String nombre;
  final List<Servicioturistico> servicios = [];

  Paquete(this.nombre);

  void agregarservicio(Servicioturistico servicio){
    servicios.add(servicio);
  }

  void eliminarservicio(Servicioturistico servicio){
    servicios.remove(servicio);
  }

  @override
  double getPrecio() {
    double suma = 0;
    for (var s in servicios) {
      suma += s.getPrecio();
    }
    return suma;
  }
}