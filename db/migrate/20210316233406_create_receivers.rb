class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.string :ein
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :filename
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
