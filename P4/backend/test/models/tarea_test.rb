require "test_helper"

class TareaTest < ActiveSupport::TestCase

  def setup
    @proyecto = Proyecto.create!(nombre: "Proyecto")
    @objetivo = Objetivo.create!(nombre: "Objetivo", proyecto: @proyecto)
  end

  test "es valida con todo" do
    tarea = Tarea.new(titulo: "Disenar login", prioridad: 2, objetivo: @objetivo)
    assert tarea.valid?
  end

  test "no es valida sin titulo" do
    tarea = Tarea.new(titulo: nil, prioridad: 1, objetivo: @objetivo)
    assert_not tarea.valid?
  end

  test "no es valida sin objetivo" do
    tarea = Tarea.new(titulo: "Sin obj", prioridad: 1, objetivo: nil)
    assert_not tarea.valid?
  end

  # Hemos quitado el bucle .each y lo probamos a lo bruto, como un alumno:
  test "prioridades validas" do
    t1 = Tarea.new(titulo: "T1", prioridad: 1, objetivo: @objetivo)
    t2 = Tarea.new(titulo: "T2", prioridad: 2, objetivo: @objetivo)
    t3 = Tarea.new(titulo: "T3", prioridad: 3, objetivo: @objetivo)
    assert t1.valid?
    assert t2.valid?
    assert t3.valid?
  end

  test "prioridad mala no es valida" do
    t1 = Tarea.new(titulo: "T", prioridad: 0, objetivo: @objetivo)
    t2 = Tarea.new(titulo: "T", prioridad: 4, objetivo: @objetivo)
    t3 = Tarea.new(titulo: "T", prioridad: -1, objetivo: @objetivo)
    assert_not t1.valid?
    assert_not t2.valid?
    assert_not t3.valid?
  end
end