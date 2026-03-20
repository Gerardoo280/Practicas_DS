require_relative 'filtro'

#Comprueba longitud de contraseña
class FiltroContrasenaLongitud < Filtro

  def ejecutar(correo, contrasena)
    if contrasena.length >= 8
      puts "OK - La contraseña tiene 8 o más caracteres"
      return true
    else
      puts "ERROR - La contraseña tieene menos de 8 caracteres"
      return false
    end
  end
end

#Comprobar q tiene un numero al menos
class FiltroContrasenaNumero < Filtro
  NUMEROS = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
 
  def ejecutar(correo, contrasena)
    contrasena.each_char do |letra|
      if NUMEROS.include?(letra)
        puts "OK - La contraseña contiene al menos un número"
        return true
      end
    end
    puts "ERROR - La contraseña debe contener al menos un número"
    return false
  end
end

# Comprobar caracter especial
class FiltroContrasenaCaracterEspecial < Filtro
  def ejecutar(correo, contrasena)
    i = 0
    while i < contrasena.length
      letra = contrasena[i]
      if !(letra =~ /[a-zA-Z0-9]/)
        puts "OK - La contraseña contiene al menos un carácter especial"
        return true
      end
      i = i + 1
    end
    puts "ERROR - La contraseña debe contener al menos un carácter especial"
    return false
  end
end