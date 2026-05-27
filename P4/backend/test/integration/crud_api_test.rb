require "test_helper"

class CrudApiTest < ActionDispatch::IntegrationTest

  test "puedo listar proyectos" do
    Proyecto.create!(nombre: "P1")
    get "/api/proyectos", headers: {"Accept" => "application/json"}
    assert_response :ok
    assert_kind_of Array, JSON.parse(response.body)
  end

  test "puedo crear un proyecto" do
    assert_difference("Proyecto.count", 1) do
      post "/api/proyectos",
           params: { proyecto: { nombre: "Nuevo", descripcion: "Desc" } },
           headers: {"Accept" => "application/json"}
    end
    assert_response :created
  end

  test "no puedo crear un proyecto sin nombre" do
    post "/api/proyectos",
         params: { proyecto: { nombre: "" } },
         headers: {"Accept" => "application/json"}
    assert_response :unprocessable_entity
  end

  test "puedo editar un proyecto" do
    p = Proyecto.create!(nombre: "Viejo")
    patch "/api/proyectos/#{p.id}",
          params: { proyecto: { nombre: "Nuevo" } },
          headers: {"Accept" => "application/json"}
    assert_response :ok
    assert_equal "Nuevo", p.reload.nombre
  end

  test "puedo borrar un proyecto" do
    p = Proyecto.create!(nombre: "Borrar")
    assert_difference("Proyecto.count", -1) do
      delete "/api/proyectos/#{p.id}", headers: {"Accept" => "application/json"}
    end
    assert_response :no_content
  end

  test "borrar un proyecto borra tambien sus objetivos y tareas" do
    p = Proyecto.create!(nombre: "Con hijos")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)
    Tarea.create!(titulo: "T1", prioridad: 1, objetivo: obj)

    delete "/api/proyectos/#{p.id}", headers: {"Accept" => "application/json"}

    assert_empty Objetivo.where(proyecto_id: p.id)
    assert_empty Tarea.where(objetivo_id: obj.id)
  end

  #objetivos
  test "puedo listar los objetivos de un proyecto" do
    p = Proyecto.create!(nombre: "P")
    Objetivo.create!(nombre: "Obj A", proyecto: p)

    get "/api/proyectos/#{p.id}/objetivos", headers: {"Accept" => "application/json"}

    assert_response :ok
    assert_equal 1, JSON.parse(response.body).length
  end

  test "puedo crear un objetivo en un proyecto" do
    p = Proyecto.create!(nombre: "P")
    assert_difference("Objetivo.count", 1) do
      post "/api/proyectos/#{p.id}/objetivos",
           params: { objetivo: { nombre: "Nuevo obj" } },
           headers: {"Accept" => "application/json"}
    end
    assert_response :created
  end

  test "no puedo crear un objetivo sin nombre" do
    p = Proyecto.create!(nombre: "P")
    post "/api/proyectos/#{p.id}/objetivos",
         params: { objetivo: { nombre: "" } },
         headers: {"Accept" => "application/json"}
    assert_response :unprocessable_entity
  end

  test "puedo editar un objetivo" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Viejo", proyecto: p)

    patch "/api/objetivos/#{obj.id}",
          params: { objetivo: { nombre: "Nuevo" } },
          headers: {"Accept" => "application/json"}

    assert_response :ok
    assert_equal "Nuevo", obj.reload.nombre
  end

  test "puedo borrar un objetivo y sus tareas desaparecen" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Borrar", proyecto: p)
    Tarea.create!(titulo: "T", prioridad: 1, objetivo: obj)

    assert_difference("Objetivo.count", -1) do
      assert_difference("Tarea.count", -1) do
        delete "/api/objetivos/#{obj.id}", headers: {"Accept" => "application/json"}
      end
    end
    assert_response :no_content
  end

  #tareas
  test "puedo listar las tareas de un objetivo" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)
    Tarea.create!(titulo: "T1", prioridad: 1, objetivo: obj)

    get "/api/objetivos/#{obj.id}/tareas", headers: {"Accept" => "application/json"}

    assert_response :ok
    assert_equal 1, JSON.parse(response.body).length
  end

  test "puedo crear una tarea en un objetivo" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)

    assert_difference("Tarea.count", 1) do
      post "/api/objetivos/#{obj.id}/tareas",
           params: { tarea: { titulo: "Nueva", prioridad: 2 } },
           headers: {"Accept" => "application/json"}
    end
    assert_response :created
  end

  test "no puedo crear una tarea sin titulo" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)

    post "/api/objetivos/#{obj.id}/tareas",
         params: { tarea: { titulo: "", prioridad: 1 } },
         headers: {"Accept" => "application/json"}
    assert_response :unprocessable_entity
  end

  test "no puedo crear una tarea con prioridad invalida" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)

    post "/api/objetivos/#{obj.id}/tareas",
         params: { tarea: { titulo: "T", prioridad: 99 } },
         headers: {"Accept" => "application/json"}
    assert_response :unprocessable_entity
  end

  test "puedo editar una tarea" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)
    t = Tarea.create!(titulo: "Viejo", prioridad: 1, objetivo: obj)

    patch "/api/tareas/#{t.id}",
          params: { tarea: { titulo: "Nuevo", prioridad: 3 } },
          headers: {"Accept" => "application/json"}

    assert_response :ok
    t.reload
    assert_equal "Nuevo", t.titulo
    assert_equal 3, t.prioridad
  end

  test "puedo borrar una tarea" do
    p = Proyecto.create!(nombre: "P")
    obj = Objetivo.create!(nombre: "Obj", proyecto: p)
    t = Tarea.create!(titulo: "Borrar", prioridad: 1, objetivo: obj)

    assert_difference("Tarea.count", -1) do
      delete "/api/tareas/#{t.id}", headers: {"Accept" => "application/json"}
    end
    assert_response :no_content
  end

end