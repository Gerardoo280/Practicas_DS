require_relative 'filtro'

# Filtro 1: Comprueba que hay texto antes del @
class FiltroCorreoTextoAntes < Filtro
  def ejecutar(credenciales)
    correo = credenciales[:correo]
    parte_antes = correo.split("@").first
    if parte_antes.nil? || parte_antes.empty?
      puts "[ERROR] El correo no tiene texto antes del @"
      return false
    end
    puts "[OK] El correo tiene texto antes del @"
    true
  end
end

# Filtro 2: Comprueba que el dominio sea gmail.com o hotmail.com
class FiltroCorreoDominio < Filtro
  DOMINIOS_VALIDOS = ["gmail.com", "hotmail.com"]

  def ejecutar(credenciales)
    correo = credenciales[:correo]
    dominio = correo.split("@").last
    if DOMINIOS_VALIDOS.include?(dominio)
      puts "[OK] El dominio '#{dominio}' es válido"
      true
    else
      puts "[ERROR] El dominio '#{dominio}' no está permitido. Solo se aceptan: #{DOMINIOS_VALIDOS.join(', ')}"
      false
    end
  end
end