import 'package:flutter_test/flutter_test.dart';
import 'package:p3/Servicioturistico/Hotel.dart';
import 'package:p3/Servicioturistico/Soloalojamiento.dart';
import 'package:p3/Servicioturistico/TarifaLowCost.dart';
import 'package:p3/Servicioturistico/Vuelo.dart';


void main() {
  group('Servicios Individuales', () {
    test('Vuelo lanza excepción al añadir precio negativo', () {
      expect(() => Vuelo(id: 'CualquierID',precioBase: -100, politica: TarifaLowCost()), throwsArgumentError);
    });
    test('Hotel rechaza 0 o menos noches', () {
      expect(() => Hotel(nombre: 'Cualquier Nombre', precioNoche: 200, noches: 0, politica: Soloalojamiento()), throwsArgumentError);
    });
    test('Hotel rechaza precio menor o igual que cero por noche', () {
      expect(() => Hotel(nombre: 'Cualquier Nombre', precioNoche: -5, noches: 4, politica: Soloalojamiento()), throwsArgumentError);
    });

    test('getPrecio() de Vuelo delega en su política asignada', () {
      const double precioBase = 100;
      final politica = TarifaLowCost();
      final vuelo = Vuelo(id: 'V1', precioBase: precioBase, politica: politica);

      expect(vuelo.getPrecio(), closeTo(politica.calcular(precioBase) , 0.01));
    });

    test('getPrecio() de Hotel retorna el valor procesado por su régimen', () {
      const double precioNoche = 50.0;
      const int noches = 3;
      final politica = Soloalojamiento();
      final hotel = Hotel(nombre: 'H1', precioNoche: precioNoche, noches: noches, politica: politica);

      expect(hotel.getPrecio(), closeTo(politica.calcular(precioNoche, noches), 0.01));
    });
  });
}
