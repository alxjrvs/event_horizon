class CreateSubmissionGrades < ActiveRecord::Migration
  def change
    create_table :submission_grades do |t|
      t.integer :submission_id, null: false
      t.integer :score, null: false
      t.text :comment

      t.timestamps
    end
  end
end
