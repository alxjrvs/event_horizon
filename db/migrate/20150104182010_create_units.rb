class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
  end
end
