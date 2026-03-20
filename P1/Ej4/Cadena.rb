#Comprueba que se cumple todo
class Cadena
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

  def ejecutar(correo, contrasena)
    i = 0
    while i < @filtros.length
      filtro = @filtros[i]
      resultado = filtro.ejecutar(correo, contrasena)
      if resultado == false
        return false
      end
      i = i + 1
    end
    if @objetivo != nil
      @objetivo.ejecutar(correo, contrasena)
    end
    return true
  end

end