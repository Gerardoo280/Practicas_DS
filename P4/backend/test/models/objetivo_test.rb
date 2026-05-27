require "test_helper"

class ObjetivoTest < ActiveSupport::TestCase

  def setup
    @proyecto = Proyecto.create!(nombre: "Proyecto base")
  end

  test "es valido con nombre y proyecto" do
    obj = Objetivo.new(nombre: "Lanzar v1.0", proyecto: @proyecto)
    assert obj.valid?
  end

  test "no es valido sin nombre" do
    obj = Objetivo.new(nombre: nil, proyecto: @proyecto)
    assert_not obj.valid?
  end

  test "no es valido sin proyecto asociado" do
    obj = Objetivo.new(nombre: "Objetivo huerfano")
    assert_not obj.valid?
  end

  test "un objetivo puede tener multiples tareas" do
    obj = Objetivo.create!(nombre: "Con tareas", proyecto: @proyecto)
    Tarea.create!(titulo: "T1", prioridad: 1, objetivo: obj)
    Tarea.create!(titulo: "T2", prioridad: 2, objetivo: obj)
    
    assert_equal 2, obj.tareas.count
  end

  test "elimina en cascada sus tareas" do
    obj = Objetivo.create!(nombre: "Con tareas", proyecto: @proyecto)
    Tarea.create!(titulo: "T1", prioridad: 1, objetivo: obj)
    Tarea.create!(titulo: "T2", prioridad: 3, objetivo: obj)
    
    assert_difference("Tarea.count", -2) do
      obj.destroy
    end
  end
end