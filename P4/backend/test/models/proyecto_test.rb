require "test_helper"

class ProyectoTest < ActiveSupport::TestCase

  test "es valido con nombre" do
    proyecto = Proyecto.new(nombre: "App movil")
    assert proyecto.valid?
  end

  test "no es valido sin nombre" do
    proyecto = Proyecto.new(nombre: nil)
    assert_not proyecto.valid?
  end

  test "no es valido con nombre vacio" do
    proyecto = Proyecto.new(nombre: "")
    assert_not proyecto.valid?
  end

  test "se guarda en la base de datos" do
    assert_difference("Proyecto.count", 1) do
      Proyecto.create!(nombre: "Proyecto nuevo", descripcion: "Una descripcion")
    end
  end

  test "elimina en cascada sus objetivos" do
    p = Proyecto.create!(nombre: "Con objetivos")
    Objetivo.create!(nombre: "Obj 1", proyecto: p)
    Objetivo.create!(nombre: "Obj 2", proyecto: p)
    
    assert_difference("Objetivo.count", -2) do
      p.destroy
    end
  end
end