require_relative 'filtro'

# Filtro 3: Comprueba que la contraseña tiene al menos 8 caracteres
class FiltroContrasenaLongitud < Filtro
  LONGITUD_MINIMA = 8

  def ejecutar(credenciales)
    contrasena = credenciales[:contrasena]
    if contrasena.length >= LONGITUD_MINIMA
      puts "[OK] La contraseña tiene al menos #{LONGITUD_MINIMA} caracteres"
      true
    else
      puts "[ERROR] La contraseña es demasiado corta. Mínimo #{LONGITUD_MINIMA} caracteres"
      false
    end
  end
end

# Filtro 4: Comprueba que la contraseña tiene al menos un número
class FiltroContrasenaNumero < Filtro
  def ejecutar(credenciales)
    contrasena = credenciales[:contrasena]
    if contrasena.match?(/\d/)
      puts "[OK] La contraseña contiene al menos un número"
      true
    else
      puts "[ERROR] La contraseña debe contener al menos un número"
      false
    end
  end
end

# Filtro 5: Comprueba que la contraseña tiene al menos un carácter especial
class FiltroContrasenaCaracterEspecial < Filtro
  def ejecutar(credenciales)
    contrasena = credenciales[:contrasena]
    if contrasena.match?(/[!@#$%^&*()_+\-=\[\]{}|;':",.<>?\/\\]/)
      puts "[OK] La contraseña contiene al menos un carácter especial"
      true
    else
      puts "[ERROR] La contraseña debe contener al menos un carácter especial (!@#$%...)"
      false
    end
  end
end