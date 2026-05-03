import 'package:flutter_test/flutter_test.dart';
import 'package:p3/Servicioturistico/Soloalojamiento.dart';
import 'package:p3/Servicioturistico/TarifaBusiness.dart';
import 'package:p3/Servicioturistico/TarifaLowCost.dart';
import 'package:p3/Servicioturistico/Todoincluido.dart';

void main() {
  group('Políticas de Tarifación', () {
    test('Tarifa Low Cost añade su recargo', () {
      final tarifaLowCost = TarifaLowCost();
      double precioBase = 10;

      double result = tarifaLowCost.calcular(precioBase);

      expect(result, closeTo(precioBase + TarifaLowCost.COSTE_ADICIONAL, 0.01));
    });
    test('Tarifa Low Business aplica multiplicador', () {
      final tarifaBusiness = TarifaBusiness();
      double precioBase = 10;

      double result = tarifaBusiness.calcular(precioBase);

      expect(result, closeTo(precioBase * TarifaBusiness.MULTIPLICADOR, 0.01));
    });

    test('Calcular precio exacto de noches por alojamiento', () {
      final tarifaAlojamiento = Soloalojamiento();
      double precioNoche = 10;
      int numNoches = 2;

      double result = tarifaAlojamiento.calcular(precioNoche, numNoches);

      expect(result, closeTo(precioNoche * numNoches, 0.01));
    });

    test('Calcular precio de todo incluido', () {
      final tarifaTodoIncluido = Todoincluido();
      double precioNoche = 10;
      int numNoches = 2;

      double result = tarifaTodoIncluido.calcular(precioNoche, numNoches);

      expect(result, closeTo((precioNoche + Todoincluido.SUPLEMENTO) * numNoches , 0.01));
    });
  });
}
