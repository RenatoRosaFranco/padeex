class CreateInvestmentInterests < ActiveRecord::Migration[8.1]
  def change
    create_table :investment_interests do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :investment_range, null: false
      t.text :message

      t.timestamps
    end

    add_index :investment_interests, :email
  end
end
