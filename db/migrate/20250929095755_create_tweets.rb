class CreateTweets < ActiveRecord::Migration[8.0]
  def change
    create_table :tweets do |t|
      t.string :place_name
      t.string :price
      t.string :location
      t.text :knowledge

      t.timestamps
    end
  end
end
