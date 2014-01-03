json.array!(@instagram_accts) do |instagram_acct|
  json.extract! instagram_acct, :id, :access_token, :instagram_user_id, :username, :full_name, :profile_pic, :user_id
  json.url instagram_acct_url(instagram_acct, format: :json)
end