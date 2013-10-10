class Tourney < ActiveRecord::Base
  has_many :players
  has_many :scorecards, through: :players
  validates :name, presence: true, length: { minimum: 5 }
end
