# CadenaFiltros: guarda la lista de filtros y los ejecuta uno a uno
# Al final, si todo ha ido bien, llama al objetivo (Autenticacion)
class CadenaFiltros
  def initialize
    @filtros = []
    @objetivo = nil
  end

  def agregar_filtro(filtro)
    @filtros << filtro
  end

  def establecer_objetivo(objetivo)
    @objetivo = objetivo
  end

  def ejecutar(credenciales)
    @filtros.each do |filtro|
      resultado = filtro.ejecutar(credenciales)
      # Si un filtro falla, paramos la cadena
      return false unless resultado
    end
    # Si todos los filtros pasan, ejecutamos el objetivo
    @objetivo.ejecutar(credenciales) if @objetivo
    true
  end
end