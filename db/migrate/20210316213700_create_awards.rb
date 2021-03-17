class CreateAwards < ActiveRecord::Migration[6.0]
  def change
    create_table :awards do |t|
      t.string :ein
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.decimal :amount, precision: 20, scale: 2
      t.decimal :amount_gbp, precision: 20, scale: 2
      t.string :purpose
      t.string :filer_ein
      t.string :filename
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
