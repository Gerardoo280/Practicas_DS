# Clase abstracta Filtro
# Todos los filtros deben heredar de esta clase e implementar el método ejecutar
class Filtro
  def ejecutar(credenciales)
    raise NotImplementedError, "Cada filtro debe implementar el método ejecutar"
  end
end