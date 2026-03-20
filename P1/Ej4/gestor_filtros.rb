require_relative 'cadena'

# Objetivo: la clase que procesa la autenticación si todos los filtros pasan
class Autenticacion
  def ejecutar(credenciales)
    puts "\n✓ Autenticación completada con éxito para: #{credenciales[:correo]}"
  end
end

# GestorFiltros: crea la cadena y gestiona qué filtros se añaden
class GestorFiltros
  def initialize
    @cadena = CadenaFiltros.new
    objetivo = Autenticacion.new
    @cadena.establecer_objetivo(objetivo)
  end

  def agregar_filtro(filtro)
    @cadena.agregar_filtro(filtro)
  end

  def procesar_peticion(credenciales)
    @cadena.ejecutar(credenciales)
  end
end