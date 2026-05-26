class CreateTareas < ActiveRecord::Migration[8.1]
  def change
    create_table :tareas do |t|
      t.text       :titulo,       null: false
      t.boolean    :completada,   null: false, default: false
      t.integer    :prioridad,    null: false, default: 1
      t.date       :fecha_limite
      t.references :objetivo,     null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
    
    add_check_constraint :tareas, "prioridad IN (1, 2, 3)", name: "chk_tareas_prioridad"
  end
end
