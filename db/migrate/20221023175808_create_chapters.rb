class CreateChapters < ActiveRecord::Migration[6.1]
  def up
    create_table :chapters do |t|
      t.string :title, null: false
      t.references :course, foreign_key: true, null: false, index: false
      t.integer :sequence, null: false

      t.timestamps
    end

    add_index :chapters, [:course_id, :sequence],
              unique: true,
              name: 'unique_index_course_id_with_sequence'
  end

  def down
    drop_table :chapters if table_exists?(:chapters)
  end
end
