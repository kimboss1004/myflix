class AddLargeUrl < ActiveRecord::Migration
  def change
    add_column :videos, :large_url, :string
  end
end
