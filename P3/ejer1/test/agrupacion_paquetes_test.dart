import 'package:flutter_test/flutter_test.dart';
import 'package:p3/Servicioturistico/Hotel.dart';
import 'package:p3/Servicioturistico/Paquete.dart';
import 'package:p3/Servicioturistico/Soloalojamiento.dart';
import 'package:p3/Servicioturistico/TarifaBusiness.dart';
import 'package:p3/Servicioturistico/TarifaLowCost.dart';
import 'package:p3/Servicioturistico/Vuelo.dart';

void main() {
  group('Agrupación de Paquetes', () {
    test('Paquete recien creado devuelve un precio de 0', () {
      final paquete = Paquete('Prueba');

      expect(paquete.getPrecio(), closeTo(0, 0.1));
    });

    test('El método getPrecio() deveuelve la suma aritmética de sus componentes directos', () {
      final vuelo = Vuelo(id: 'V1', precioBase: 100.0, politica: TarifaLowCost());
      final hotel = Hotel(nombre: 'H1', precioNoche: 50.0, noches: 2, politica: Soloalojamiento());
      final paquete = Paquete('P1');

      paquete.agregarservicio(vuelo);
      paquete.agregarservicio(hotel);

      final precioEsperado = vuelo.getPrecio() + hotel.getPrecio();
      expect(paquete.getPrecio(), closeTo(precioEsperado, 0.01));
    });

    test('El precio de paquetes dentro de otros se suma correctamente', () {
      final vuelo = Vuelo(id: 'V1', precioBase: 100.0, politica: TarifaLowCost());
      final paquete = Paquete('P1');

      paquete.agregarservicio(vuelo);

      final paquete2 = Paquete('P2');
      final hotel = Hotel(nombre: 'H1', precioNoche: 50.0, noches: 2, politica: Soloalojamiento());
      paquete2.agregarservicio(hotel);

      paquete.agregarservicio(paquete2);

      final precioEsperado = vuelo.getPrecio() + hotel.getPrecio();
      expect(paquete.getPrecio(), closeTo(precioEsperado, 0.01));
    });

    test('Cambiar política de vuelo actualiza precio del paquete raíz', () {
      final vuelo = Vuelo(id: 'V1', precioBase: 100.0, politica: TarifaLowCost());
      final paquete = Paquete('P1');
      paquete.agregarservicio(vuelo);

      final precioAntes = paquete.getPrecio();

      vuelo.politica = TarifaBusiness();

      expect(paquete.getPrecio(), isNot(closeTo(precioAntes, 0.01)));
      expect(paquete.getPrecio(), closeTo(100.0 * TarifaBusiness.MULTIPLICADOR, 0.01));
    });

  });
}