class Player < ActiveRecord::Base
  belongs_to :tourney
  has_many :scorecards
  accepts_nested_attributes_for :scorecards

  validates :tourney, :sbs_player_id, :first_name, :handicap, presence: true
  validates :sbs_player_id, :handicap, numericality: true
end
