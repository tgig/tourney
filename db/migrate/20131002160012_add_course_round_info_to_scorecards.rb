class AddCourseRoundInfoToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :course_name, :string
    add_column :scorecards, :course_city, :string
    add_column :scorecards, :course_state, :string
    add_column :scorecards, :course_country, :string
    add_column :scorecards, :round_date, :timestamp
  end
end
