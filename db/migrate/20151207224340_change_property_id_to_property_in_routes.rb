class ChangePropertyIdToPropertyInRoutes < ActiveRecord::Migration
  def up
    remove_column :routes, :property_id
    add_column :routes, :property, :string
  end

  def down
    remove_column :routes, :property
    add_column :routes, :property_id, :integer
  end
end
