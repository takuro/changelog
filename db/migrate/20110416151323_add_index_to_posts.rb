class AddIndexToPosts < ActiveRecord::Migration
  def self.up
    add_index :posts, [:permalink], :name => :permalink_idx
  end

  def self.down
    remove_index :posts, :name => :permalink_idx
  end
end
