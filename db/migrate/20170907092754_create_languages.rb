class CreateLanguages < ActiveRecord::Migration[5.1]
  def change
    create_table :languages do |t|
      t.string :name
      t.text :lang_type # type is protected, because STI
      t.string :designed_by
      t.timestamps
    end
  end
end
