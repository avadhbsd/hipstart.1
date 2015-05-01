json.array!(@profiles) do |profile|
  json.extract! profile, :id, :user_id, :name, :short_bio, :youtube_url, :facebok_url, :twitter_url, :user_id
  json.url profile_url(profile, format: :json)
end
