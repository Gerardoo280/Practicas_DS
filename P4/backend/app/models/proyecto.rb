class Proyecto < ApplicationRecord
  has_many :objetivos, dependent: :destroy

  validates :nombre, presence: true
end
