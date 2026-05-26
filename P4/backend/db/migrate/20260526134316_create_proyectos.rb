class CreateProyectos < ActiveRecord::Migration[8.1]
  def change
    create_table :proyectos do |t|
      t.text    :nombre,      null: false
      t.text    :descripcion, null: false, default: ''
      t.timestamps
    end
  end
end
