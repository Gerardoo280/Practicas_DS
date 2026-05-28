# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_26_134354) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "objetivos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "nombre", null: false
    t.bigint "proyecto_id", null: false
    t.datetime "updated_at", null: false
    t.index ["proyecto_id"], name: "index_objetivos_on_proyecto_id"
  end

  create_table "proyectos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descripcion", default: "", null: false
    t.text "nombre", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tareas", force: :cascade do |t|
    t.boolean "completada", default: false, null: false
    t.datetime "created_at", null: false
    t.date "fecha_limite"
    t.bigint "objetivo_id", null: false
    t.integer "prioridad", default: 1, null: false
    t.text "titulo", null: false
    t.datetime "updated_at", null: false
    t.index ["objetivo_id"], name: "index_tareas_on_objetivo_id"
    t.check_constraint "prioridad = ANY (ARRAY[1, 2, 3])", name: "chk_tareas_prioridad"
  end

  add_foreign_key "objetivos", "proyectos", on_delete: :cascade
  add_foreign_key "tareas", "objetivos", on_delete: :cascade
end
