class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :due_date
      t.references :catogory, null: false, foreign_key: true

      t.timestamps
    end
  end
end
