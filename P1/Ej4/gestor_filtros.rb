require_relative 'Cadena'

# Objetivo: la clase que procesa la autenticación si todos los filtros pasan
class Autenticacion
  def ejecutar(correo, contrasena)
    puts "\n Autenticación completada con éxito para: #{correo}"
  end
end

class GestorFiltros
  def initialize
    @cadena = Cadena.new
    objetivo = Autenticacion.new
    @cadena.establecer_objetivo(objetivo)
  end

  def agregar_filtro(filtro)
    @cadena.agregar_filtro(filtro)
  end

  def procesar_peticion(correo, contrasena)
    @cadena.ejecutar(correo, contrasena)
  end
end