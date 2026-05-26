class Tarea < ApplicationRecord
  belongs_to :objetivo

  validates :titulo,    presence: true
  validates :prioridad, inclusion: { in: [1, 2, 3] }
end
