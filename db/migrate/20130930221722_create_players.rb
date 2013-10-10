class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :sbs_player_id
      t.string :first_name
      t.string :last_name
      t.decimal :handicap
      t.references :tourney, index: true

      t.timestamps
    end
  end
end
