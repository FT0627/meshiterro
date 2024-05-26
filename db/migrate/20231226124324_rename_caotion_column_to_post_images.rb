class RenameCaotionColumnToPostImages < ActiveRecord::Migration[6.1]
  def change
    rename_column :post_images, :caotion, :caption
  end
end
