class AddParkingToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :parking, :string
  end
end
