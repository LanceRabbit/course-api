class CreateLessons < ActiveRecord::Migration[6.1]
  def up
    create_table :lessons do |t|
      t.string :title, null: false
      t.string :description
      t.text :content, null: false
      t.integer :sequence, null: false
      t.references :chapter, foreign_key: true, null: false, index: false

      t.timestamps
    end

    add_index :lessons, [:chapter_id, :sequence],
              unique: true,
              name: 'unique_index_chapter_id_with_sequence'
  end

  def down
    drop_table :lessons if table_exists?(:lessons)
  end
end
