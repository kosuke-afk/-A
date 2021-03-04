class Base < ApplicationRecord
  validates :base_name, presence: true, length: { maximum: 30}
  validates :base_number, presence: true, numericality: {only_integer: true}
  validates :kind, presence: true
end
