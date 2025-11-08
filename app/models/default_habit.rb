class DefaultHabit < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
