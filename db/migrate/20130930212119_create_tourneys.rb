class CreateTourneys < ActiveRecord::Migration
  def change
    create_table :tourneys do |t|
      t.string :name
      t.text :description
      t.timestamp :startdate
      t.timestamp :enddate

      t.timestamps
    end
  end
end
