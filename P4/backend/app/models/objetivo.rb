class Objetivo < ApplicationRecord
  belongs_to :proyecto
  has_many :tareas, dependent: :destroy

  validates :nombre, presence: true
end
