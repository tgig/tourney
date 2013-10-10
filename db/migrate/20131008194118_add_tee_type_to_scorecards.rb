class AddTeeTypeToScorecards < ActiveRecord::Migration
  def change
    add_column :scorecards, :tee_box, :string
  end
end
