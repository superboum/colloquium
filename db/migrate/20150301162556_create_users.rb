class CreateUsers < ActiveRecord::Migration
  def change
	create_table :users do |t|
		t.string :first_name
		t.string :last_name
		t.string :email
		t.string :password
		t.string :phone
		t.string :address
		t.integer :role
		t.integer :diet
		t.string :nationality
		t.string :title
		t.integer :sex
		t.boolean :has_paid
		t.datetime :created_at
		t.datetime :updated_at
		t.date :birth
	end
  end
end
