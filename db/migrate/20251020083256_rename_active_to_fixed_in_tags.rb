class RenameActiveToFixedInTags < ActiveRecord::Migration[8.0]
  def change
    rename_column :tags, :active, :fixed
  end
end
