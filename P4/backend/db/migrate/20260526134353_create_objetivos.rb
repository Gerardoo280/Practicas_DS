class CreateObjetivos < ActiveRecord::Migration[8.1]
  def change
    create_table :objetivos do |t|
      t.text       :nombre,      null: false
      t.references :proyecto,    null: false, foreign_key: { on_delete: :cascade }
      t.timestamps
    end
  end
end
