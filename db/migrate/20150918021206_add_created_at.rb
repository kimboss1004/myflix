class AddCreatedAt < ActiveRecord::Migration
  def change
    add_column :videos, :created_at, :timestamp
    add_column :videos, :updated_at, :timestamp
  end
end
