class CreatePhoneNumbers < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.integer :contact_id
      t.string :contact_type

      t.timestamps null: false
    end
    add_index :phone_numbers, :contact_id
  end
end
