class CreateScorecards < ActiveRecord::Migration
  def change
    create_table :scorecards do |t|
      t.integer :sbs_round_id
      t.integer :sbs_scorecard_id
      t.string :score_type_front_back_full
      t.integer :course_rating
      t.integer :course_slope
      t.integer :player_course_handicap
      t.integer :raw_score
      t.integer :handicap_adjusted_score
      t.integer :stableford_score
      t.string :round_track_url
      t.references :player, index: true

      t.timestamps
    end
  end
end
