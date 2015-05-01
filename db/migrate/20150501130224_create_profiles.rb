class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :name
      t.string :short_bio
      t.string :youtube_url
      t.string :facebok_url
      t.string :twitter_url
      t.references :user, index: true

      t.timestamps
    end
  end
end
