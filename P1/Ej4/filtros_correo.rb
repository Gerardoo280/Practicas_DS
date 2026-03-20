require_relative 'filtro'

class FiltroCorreoTextoAntes < Filtro
  def ejecutar(correo, contrasena)
    posicion_arroba = correo.index("@")

    if posicion_arroba == nil || posicion_arroba == 0
      puts "ERROR - El correo no tiene texto antes del @"
      return false
    end

    puts "OK - El correo tiene texto antes del @"
    return true
  end
end


class FiltroCorreoDominio < Filtro

  def ejecutar(correo, contrasena)
    posicion_arroba = correo.index("@")
    dominio = correo[posicion_arroba + 1, correo.length]

    if dominio == "gmail.com" || dominio == "hotmail.com" || dominio == "correo.ugr.es" || dominio == "go.ugr.es"
      puts "OK - El dominio '#{dominio}' es correcto y válido"
      return true
    else
      puts "ERROR - El dominio '#{dominio}' no es válido. Solo son validos gmail.com, hotmail.com, correo.ugr.es y go.ugr.es"
      return false
    end
  end
end