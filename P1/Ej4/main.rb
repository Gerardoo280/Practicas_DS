require_relative 'gestor_filtros'
require_relative 'filtros_correo'
require_relative 'filtros_contrasena'

puts "    Sistema de Autenticación "
print "Introduce tu correo: "
correo = gets.chomp

print "Introduce tu contraseña: "
contrasena = gets.chomp

gestor = GestorFiltros.new

#Filtros 
gestor.agregar_filtro(FiltroCorreoTextoAntes.new)
gestor.agregar_filtro(FiltroCorreoDominio.new)
gestor.agregar_filtro(FiltroContrasenaLongitud.new)
gestor.agregar_filtro(FiltroContrasenaNumero.new)
gestor.agregar_filtro(FiltroContrasenaCaracterEspecial.new)

resultado = gestor.procesar_peticion(correo, contrasena)

unless resultado
  puts "\n Autenticación fallida. Revisa los errores anteriores."
end