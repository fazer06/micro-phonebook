class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      #t.string :number
      t.string :company_name

      t.timestamps null: false
    end
  end
end
