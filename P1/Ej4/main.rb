require_relative 'gestor_filtros'
require_relative 'filtros_correo'
require_relative 'filtros_contrasena'

# Cliente: pide los datos al usuario y lanza la validación
puts "=== Sistema de Autenticación ==="
print "Introduce tu correo: "
correo = gets.chomp

print "Introduce tu contraseña: "
contrasena = gets.chomp

credenciales = { correo: correo, contrasena: contrasena }

# Creamos el gestor y añadimos los filtros
gestor = GestorFiltros.new

# Filtros del correo
gestor.agregar_filtro(FiltroCorreoTextoAntes.new)
gestor.agregar_filtro(FiltroCorreoDominio.new)

# Filtros de la contraseña
gestor.agregar_filtro(FiltroContrasenaLongitud.new)
gestor.agregar_filtro(FiltroContrasenaNumero.new)
gestor.agregar_filtro(FiltroContrasenaCaracterEspecial.new)

puts "\n--- Validando credenciales ---"
resultado = gestor.procesar_peticion(credenciales)

unless resultado
  puts "\n✗ Autenticación fallida. Revisa los errores anteriores."
end