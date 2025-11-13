class AddCategoryIdToTweets < ActiveRecord::Migration[8.0]
  def change
    add_column :tweets, :category_id, :integer
  end
end
